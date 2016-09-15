#include <QtGui/QApplication>
#include <QProcess>
#include <QSplashScreen>


int main(int argc, char** argv)
{
	QApplication app(argc, argv);

	const QString program = "./The Power of Fire.exe";
	QStringList arguments;
	arguments << "-window" << "fusion";

	QPixmap pixmap(":/cropped-dmdf.jpg");
	QSplashScreen splash(pixmap);
	splash.show();
	app.processEvents();

	QProcess *myProcess = new QProcess(&app);
	myProcess->start(program, arguments);

	myProcess->waitForFinished();

	splash.close();

	return 0;
	//return app.exec();
}
