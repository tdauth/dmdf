#include <QApplication>
#include <QMessageBox>
#include <QProcess>
#include <QSplashScreen>


int main(int argc, char** argv)
{
	QApplication app(argc, argv);

	const QString program = "../TPoF.exe";
	QStringList arguments;
	// Warcraft III's splash screen has a size of 500x400 which has to be hidden.
	QPixmap pixmap(":/cropped-dmdf.jpg");
	QSplashScreen splash(pixmap, Qt::WindowStaysOnTopHint);
	splash.showMessage(QObject::tr("Copyright 2003 Blizzard Entertainment. All rights reserved. (Warcraft III: The Frozen Throne)"), Qt::AlignCenter | Qt::AlignBottom, QColor(0xFFCC00));
	splash.show();
	app.processEvents();

	QProcess *myProcess = new QProcess(&app);
	myProcess->start(program, arguments);
	myProcess->waitForFinished();

	/*
	while (!myProcess->waitForFinished(500))
	{
		splash.repaint();
		splash.raise();
		app.processEvents();
	}
	*/

	splash.close();

	return 0;
	//return app.exec();
}
