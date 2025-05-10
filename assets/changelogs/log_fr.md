## Version Actuelle (0.5) - 08/05/2025
**Nouveaux ajouts**:
- Il est désormais possible de *se déconnecter à distance*. Si vous n'avez plus accès à un de vos appareils et souhaitez vous déconnecter, connectez-vous depuis un autre appareil, effectuez un appui long sur celui que vous souhaitez déconnecter, puis appuyez sur `Dissocier`.
- L'analyse peut désormais être *annulée* en appuyant sur le bouton `Annuler` à l'écran d'analyse.
- Ajout de l'option **analyser à partir d'un répertoire** : L'utilisateur peut maintenant choisir le dossier à analyser en appuyant sur le bouton `Analyser un dossier`. Plus besoin d'attendre que l'analyse passe par tout le système !

**Corrections**:
- La **programmation parallèle** a été mise en place pour que l'analyse fonctionne de manière totalement indépendante de l'application.

## Versions Précédentes
### Version 0.4 - 02/02/2025
**Nouveaux ajouts**:
- L'option permettant de **changer la couleur** a été ajoutée à l'interface. *"Le fait qu'il n'y ait qu'une seule couleur semblait un peu ennuyeux, alors maintenant l'utilisateur peut choisir entre 14 options différentes : 7 couleurs alternant les modes clair et sombre"*.

**Corrections**:
- La mise en réseau devrait maintenant fonctionner sans aucun problème.

### Version 0.3 - 23/01/2025
**Nouveaux ajouts**:
- **L'analyse de fichiers** a été implémentée et testée sur Windows et Android.
- L'utilisateur peut également **restaurer les fichiers mis en quarantaine**\
*"Il m'a semblé étrange que l'utilisateur puisse voir les fichiers supprimés mais ne puisse rien y faire, alors il peut désormais les restaurer à ses propres risques"*
- Lorsque l'ordinateur détecte un fichier contenant un virus, il envoie une notification à l'écran de l'utilisateur pour l'informer qu'il a mis ledit fichier en quarantaine

**Corrections**:
- L'accès des utilisateurs et des appareils a été modifié\
*"Nous avons trouvé plusieurs problèmes avec les bases de données, donc pour l'instant, nous allons travailler avec un service API afin que les utilisateurs puissent accéder à leurs comptes et appareils"*

Pour effectuer les tests nécessaires, une émulation d'un fichier malveillant est proposée en cliquant [ici](www.google.es)

L'éventuelle mauvaise expérience dans l'analyse des dossiers est regrettée, certains aspects doivent encore être améliorés.

## Version 0.2 - 15/01/2025
**Nouveaux ajouts**:
- La section "Version de l'app" a été ajoutée
- Des fonctionnalités d'accessibilité des utilisateurs ont été implémentées
- Un changement dans le menu de navigation a été implémenté sur l'écran principal :
	- Si l'écran a la taille d'un téléphone portable, il sera visible en bas
	- Si l'écran est trop petit ou plus grand que celui d'un téléphone portable, il sera visible sur le côté gauche.
- Analyse en cours : Ajout d'une visite en arrière-plan avec MacOS

**Corrections** :
- L'utilisateur ne peut plus saisir plus d'une fois un fichier interdit

### Version 0.1 - 05/01/2025
***Début de l' app***\
**Nouveaux ajouts*** :
- L'exploitation des bases de données locales et réseau a été mise en place
- La connexion et l'inscription ont été mises en œuvre
- Vous pouvez ajouter et supprimer des dossiers interdits de votre ordinateur
- Vous pouvez modifier la photo de profil de l'utilisateur en cliquant sur la photo dans son menu respectif
- Boutons fonctionnels, vous pouvez modifier le nom d'utilisateur, le mot de passe, etc.
- Analyse en cours : Le bouton scanne actuellement les fichiers Android et Windows, sans analyse faute d'API ou de ressource de détection des h.
- Les préférences de l'utilisateur sont enregistrées dans une base de données locale afin qu'elles se chargent dès l'ouverture de l'application.
- L'utilisateur peut voir les appareils liés à son compte
- Création d'un concept de liste de fichiers en quarantaine. Votre résultat actuel n'est pas connu car il n'y a pas de fonction d'analyse
- Ajout des modes clair et sombre et prise en charge des langues.