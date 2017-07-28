#include <QtCore>
#include <QtGui>
#include <QtWidgets>

#include <thread>

int main(int argc, char** argv)
{
	QApplication app(argc, argv);

	const QString REGISTRY_KEY = "HKEY_CURRENT_USER\\Software\\Blizzard Entertainment\\Warcraft III";
	const QString REGISTRY_LOCAL_FILES_ENTRY = "Allow Local Files";
	const QString REGISTRY_FROZEN_THRONE_ENTRY = "ProgramX";

	QString warcraft3Dir;

	/*
	 * Modify the registry entry "Allow Local Files" and enable it.
	 * The directories of TPoF have to be in the Warcraft III directory, so they can be accessed by Warcraft III.
	 * This should work on Windows 8 and 10 as well.
	 * "HKEY_CURRENT_USER\Software\Blizzard Entertainment\Warcraft III" and add the Registry entry "Allow Local Files" of type DWORD (32 Bit) with the value 1.
	 */
	{
		QSettings settings(REGISTRY_KEY, QSettings::NativeFormat);
		settings.setValue(REGISTRY_LOCAL_FILES_ENTRY, 1);
		warcraft3Dir = settings.value(REGISTRY_FROZEN_THRONE_ENTRY).toString();
	}

	qDebug() << "Warcraft 3 dir: " << warcraft3Dir;

	if (warcraft3Dir.isEmpty() || !QFile::exists(warcraft3Dir))
	{
		warcraft3Dir = QFileDialog::getExistingDirectory(nullptr, QObject::tr("Choose Warcraft III directory"));
	}

	const QString program = warcraft3Dir;

	if (QFile::exists(program))
	{
		QStringList arguments;
		// Warcraft III's splash screen has a size of 500x400 which has to be hidden.
		QPixmap pixmap(":/cropped-dmdf.jpg");
		QSplashScreen splash(pixmap, Qt::WindowStaysOnTopHint);
		splash.showMessage(QObject::tr("Copyright 2003 Blizzard Entertainment. All rights reserved. (Warcraft III: The Frozen Throne)"), Qt::AlignCenter | Qt::AlignBottom, QColor(0xFFCC00));
		splash.show();
		app.processEvents();

		QProcess *myProcess = new QProcess(&app);
		myProcess->start(program, arguments);
		std::this_thread::sleep_for(std::chrono::seconds(4));
		splash.close();
		myProcess->waitForFinished();
	}
	else
	{
		QMessageBox::critical(0, QObject::tr("Error"), QObject::tr("Frozen Throne.exe does not exist in the chosen directory. Make sure that the registry entry \"%1\\%2\" is set properly!").arg(REGISTRY_KEY).arg(REGISTRY_FROZEN_THRONE_ENTRY));
	}

	{
		QSettings settings(REGISTRY_KEY, QSettings::NativeFormat);
		settings.setValue(REGISTRY_LOCAL_FILES_ENTRY, 0);
	}

	return 0;
}
