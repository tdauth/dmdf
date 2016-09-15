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
	QPixmap pixmap(":/cropped-dmdf-big.jpg");
	QSplashScreen splash(pixmap, Qt::WindowStaysOnTopHint);
	splash.show();
	app.processEvents();

	QProcess *myProcess = new QProcess(&app);
	myProcess->start(program, arguments);

	myProcess->waitForFinished();

	splash.close();

	return 0;
	//return app.exec();
}
