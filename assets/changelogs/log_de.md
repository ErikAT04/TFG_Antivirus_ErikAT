## Aktuelle Version (0.4) - 02/02/2025
**Neue Ergänzungen**:
- Die Option zum **Ändern der Farbe** wurde der Benutzeroberfläche hinzugefügt. *„Dass es nur eine Farbe gab, schien etwas langweilig, daher kann der Benutzer jetzt zwischen 14 verschiedenen Optionen wählen: 7 Farben, abwechselnd heller und dunkler Modus“*.

**Korrekturen**:
- Die Vernetzung sollte nun problemlos funktionieren.

## Alte Versionen
### Version 0.3 - 23/01/2025
**Neue Ergänzungen**:
- **Dateianalyse** wurde implementiert und unter Windows und Android getestet.
- Der Benutzer kann auch **unter Quarantäne gestellte Dateien wiederherstellen**\
*„Mir kam es seltsam vor, dass der Benutzer die gelöschten Dateien sehen konnte, aber nichts dagegen tun konnte, sodass er sie jetzt auf eigenes Risiko wiederherstellen kann.“*
- Wenn der Computer eine Datei mit einem Virus erkennt, sendet er eine Benachrichtigung an den Bildschirm des Benutzers, um ihn darüber zu informieren, dass er diese Datei unter Quarantäne gestellt hat.

**Korrekturen**
- Benutzer- und Gerätezugriff wurde geändert\
*„Wir haben mehrere Probleme mit den Datenbanken festgestellt, daher werden wir vorerst mit einem API-Dienst arbeiten, damit Benutzer auf ihre Konten und Geräte zugreifen können“*

Um alle notwendigen Tests durchzuführen, wird eine Emulation einer Schaddatei bereitgestellt, indem Sie auf [hier](www.google.es) klicken.

Die möglicherweise schlechten Erfahrungen bei der Dateianalyse werden bedauert, bestimmte Aspekte müssen noch verbessert werden.

### Version (0.2) - 15/01/2025
**Neuzugänge**:
- Der Abschnitt 'Anwendungsversion' wurde hinzugefügt
- Benutzerzugänglichkeitsfunktionen wurden implementiert
- Auf dem Hauptbildschirm wurde eine Änderung im Navigationsmenü implementiert:
	- Wenn der Bildschirm die Größe eines Mobiltelefons hat, wird er unten angezeigt
	- Wenn der Bildschirm übermäßig klein oder größer als der eines Mobiltelefons ist, wird er auf der linken Seite angezeigt.
- Analyse läuft: Hintergrundtour mit MacOS hinzugefügt\
**Korrekturen**:
- Der Benutzer kann eine verbotene Datei nicht mehr als einmal eingeben

### Version 0.1 - 05/01/2025
***Bewerbungsstart***\
**Neuzugänge***:
- Der Betrieb von lokalen und Netzwerkdatenbanken wurde implementiert
- Login und Registrierung wurden implementiert
- Sie können verbotene Ordner zu Ihrem Computer hinzufügen und daraus entfernen
- Sie können das Profilfoto des Benutzers ändern, indem Sie im entsprechenden Menü auf das Foto klicken
- Funktionstasten, Sie können Benutzernamen, Passwort usw. ändern.
- Analyse läuft: Die Schaltfläche scannt derzeit die Android- und Windows-Dateien, ohne dass eine Analyse erfolgt, da keine API oder Signaturerkennungsressource vorhanden ist.
- Die Präferenzen des Benutzers werden in einer lokalen Datenbank gespeichert, sodass sie geladen werden, sobald die Anwendung geöffnet wird.
- Der Benutzer kann die mit seinem Konto verknüpften Geräte sehen
- Konzept für die Liste isolierter Dateien erstellt. Ihr aktuelles Ergebnis ist nicht bekannt, da keine Analysefunktion vorhanden ist
- Hell- und Dunkelmodi sowie Sprachunterstützung hinzugefügt.