using MindWorX.SharpCraft.Modules.JassAPI;
using System;
using System.Collections.Generic;
using System.Linq;
using TinkerWorX.SharpCraft;
using System.Net;
using System.Threading;

namespace SharpCraftExtensions
{
    [Requires(typeof(JassAPIPlugin))]
    unsafe public class HttpTrickPlugin : IMapPlugin
    {
        public static JassGameCache Cache;
        public static MindWorX.SharpCraft.Modules.WarAPI.Types.HT_Node* Global;

        public static Dictionary<int, string> LastResults = new Dictionary<int, string>();
        public static Dictionary<int, int> LocalPlayerID = new Dictionary<int, int>();

        public void Initialize(PluginContext context)
        {
            if (context != PluginContext.Game)
                return;

            Natives.Add(new CheatPrototype(this.Cheat));

            ServicePointManager.DefaultConnectionLimit = 256;
        }

        public void OnMapStart()
        {
            Natives.Add(new CheatPrototype(this.Cheat));
            //Cache = Natives.InitGameCache("sc.w3v");

            //Global = Game.Jass.AsUnsafe()->VirtualMachine[0]->GlobalTable->Lookup("SharpCraftCache");
            //Global->Value = Cache.Handle.ToPointer();
        }

        private delegate void CheatPrototype(JassStringArg cheatStr);
        private void Cheat(JassStringArg cheat)
        {
            try
            {
                string cmd;
                string cheatStr = cheat.ToString();
                bool hasArgs = false;

                if (cheatStr == "SharpCraftInit")
                {
                    Cache = Natives.InitGameCache("sc.w3v");

                    Natives.StoreBoolean(Cache, "SC", "0", true);

                    return;
                }

                if (cheatStr.Contains(' '))
                {
                    cmd = cheatStr.Split(' ')[0];
                    hasArgs = true;
                }
                else
                {
                    cmd = cheatStr;
                }

                switch (cmd)
                {
                    case "StoreLastResults":

                        if (!hasArgs)
                            return;

                        cmd = cheatStr.Split(' ')[1].ToUpper();

                        List<int> toRemove = new List<int>();

                        foreach (KeyValuePair<int, string> pair in LastResults)
                        {
                            if (LocalPlayerID[pair.Key] != -1 && (Natives.GetPlayerId(JassPlayer.FromLocal()) == LocalPlayerID[pair.Key]))
                            {
                                Natives.StoreString(Cache, cmd, pair.Key.ToString(), pair.Value);
                                LocalPlayerID[pair.Key] = -1;
                            }
                            toRemove.Add(pair.Key);
                        }

                        foreach (int key in toRemove)
                            LastResults.Remove(key);

                        break;

                    case "RunSharpCraftCommand":

                        string sc_cmd = Natives.GetStoredString(Cache, "ARG", "0").ToString().ToLower();

                        string argStr = "";
                        string a;
                        int localPlayerId = Natives.GetPlayerId(JassPlayer.FromLocal());

                        for (int i = 1; i < 32; i++)
                        {
                            a = Natives.GetStoredString(Cache, "ARG", i.ToString());

                            if (a.ToLower() == "end")
                                break;

                            argStr += a + "\n";
                        }

                        string[] args = argStr.Split('\n');

                        switch (sc_cmd)
                        {
                            case "http":

                                if (args.Length == 0)
                                    return;

                                new Thread(delegate ()
                                {
                                    string response = "";
                                    int resultIndex = 0;
                                    string url = "";
                                    string method = "GET";
                                    string data = "";
                                    int player = -1;

                                    string[] split;
                                    string split_cmd;

                                    foreach (string arg in args)
                                    {
                                        if (arg.Contains('='))
                                        {
                                            split = arg.Split(new char[] { '=' }, 2);
                                            split_cmd = split[0].ToUpper().Trim().Replace(" ", "").Replace("\t", "");

                                            split[1] = split[1].Trim();

                                            if (split_cmd == "URL")
                                                url = split[1];
                                            else if (split_cmd == "ID")
                                                int.TryParse(split[1], out resultIndex);
                                            else if (split_cmd == "METHOD")
                                                method = split[1].Replace(" ", "");
                                            else if (split_cmd == "DATA")
                                                data = split[1].Replace(" ", "");
                                            else if (split_cmd == "PLAYER")
                                                int.TryParse(split[1], out player);
                                        }
                                    }

                                    if (player != -1 && localPlayerId != player)
                                        return;

                                    if (url == "")
                                        url = args[0];

                                    if (url.Substring(0, 7) != "http://")
                                        url = "http://" + url;

                                    Uri uriResult;
                                    bool result = Uri.TryCreate(url, UriKind.Absolute, out uriResult) && uriResult.Scheme == Uri.UriSchemeHttp;

                                    if (!result)
                                    {
                                        LastResults[resultIndex] = "Invalid URL: \"" + url + "\"";
                                        return;
                                    }

                                    try
                                    {
                                        if (method == "POST")
                                        {
                                            var wc = new WebClient();
                                            wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                                            response = wc.UploadString(url, data);
                                        }
                                        else
                                        {
                                            response = new WebClient().DownloadString(url);
                                        }
                                    }
                                    catch(Exception error)
                                    {
                                        response = error.ToString();
                                    }

                                    LocalPlayerID[resultIndex] = player;
                                    LastResults[resultIndex] = response;

                                }).Start();

                                break;
                        }

                        break;


                    default:
                        Natives.Cheat(cheat);

                        break;


                }
            }
            catch(Exception error)
            {
                Natives.DisplayTextToPlayer(JassPlayer.FromLocal(), 0, 0, error.ToString());
            }
        }

        public void OnMapEnd()
        {
            //throw new NotImplementedException();
        }
    }
}