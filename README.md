# footballshop_mobile
footballshop_mobile

Assaigment 7
1. Flutter renders UI as a tree of widgets, Each part describe a part of the interface.
   The framework walks the tree top-down to build Elements and RenderObjects
   Every Widget except the root has exactly has one parent or more children.
   Parents inherit data, constrains, event handling to children

   Scaffold(parent) contains a AppBar,Body(Column/ListView)

2. Widget used:
   -MaterialApp : Root of the widget tree here.
   -Scaffold : Provides the basic visual layout structure
   -AppBar :  page title "Football Shop"
   -SafeArea: Pads its child to avoid system UI intrusions
   -Center: Centers its child within the available space
   -Column: Lays out its children vertically
   -SizedBox : As spacers between buttons
   -OutlinedButton: Tappable Material button with an outlined style
   -Text: Renders button labels like "All Products", "My Products", and "Create Product".
   -SnackBar: That pop up message
   -ScaffoldMessanger: show/hide snackbar
   -StatelessWidget: define MyApp, HomePage, and ButtonsArea as stateless components


3. MaterialApp, Creates a root navigator and route table
   Enables Material components (Scaffold, AppBar, SnackBar)

4. -StatelessWidget
   Once created, its properties cannot change
   does not have a state that can be updated during its lifetime
   ommonly becomes the root
   
   -StatefulWidget
   object that can change over time.
   rebuilds when data changes
   handle user interaction, animations


5. BuildContext is an object that serves as a handle to the location of a widget within the widget tree. 
   It represents the context in which a specific widget is built and exists.
   Every build method receives a BuildContext corresponding to the current widget’s position.
   (showing a SnackBar must use a context that has a ScaffoldMessenger above it)


6. Hot reload
   Injects updated source code into the running Dart VM and rebuilds the widget tree.
   certain type/structural changes might not fully apply

   Hot restart
   Restarts the app without a full device process kill, clearing the Dart VM state,Re‑runs main(); all State objects are recreated.
   



Assaigment 8
1. Navigator.push()
   Pushes a new page on top of the current one. The previous page stays in the stack, can be popped to go to the previous page
   Navigator.pushReplacement()
   Replaces the current page with a new one. The previous page is removed from the stack
   
2. Scaffold provides the basic layout structure for a Material page: appBar, drawer
   AppBar gives a consistent page title and actions.
   Drawer offers app-wide navigation (Home, Add Product) that appears on every main page.
   The hierarchy helps with consistentcy and easier structure by providing the drawer


3. -Padding, Makes it easier to tap the buttons

   
   Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),


   -ListView, prevents overflow and keeps the Save button reachable.


  child: ListView(
  padding: const EdgeInsets.all(16),
  children: [
    SizedBox(
      height: 56,
      child: FilledButton.icon(
        icon: const Icon(Icons.save_outlined),
        label: const Text('Save'),
        onPressed: _onSave,



   -SingleChildScrollView, Makes it as a scrollable form

   SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: const [
      // TextFormFields, Dropdowns, etc.




4. using ThemeData ,then using the parameters of colorScheme, and seedColor









Assaigment 9





1. For Easier maintainability, If we directly mapped the data immediately we would lose type safety, get more runtime errors, and the code would quickly become harder to understand and maintain as the project grows.

2.    http package
   -Does not automatically manage cookies or Django sessions.
   -Gives us basic methods: get, post, put, etc.

      pbp_django_auth
   -Stores cookies (sessionID) returned by Django on login.
   -Automatically sends those cookies with every next request, so Django knows which user is logged in.
   -Provides convenience methods, e.g. login, logout, postJson, get.


3. -Single session for the whole app: Any page that uses the same CookieRequest instance will automatically send the same cookie and be recognized as the same logged-in user.
   -Easier state management : By putting CookieRequest in a Provider, every widget can access it without manually passing it through constructors.


4. 127.0.0.1 are used when we run Flutter in Chrome.
      -Android Emulator uses 10.0.2.2 as the “special” IP that points to the host machine’s localhost:8000
      -If we don’t add them to ALLOWED_HOSTS, Django will return a 400 “Bad Request (Invalid host header)”.
   CORS are used for a web app served from http://localhost:<flutter_port> is allowed to call http://localhost:8000
      -If this isn’t configured properly: cookies might be not be properly sent(blocked or doesnt get sent)
      -Django would see all requests as “not authenticated” even after a successful login.
   <uses-permission android:name="android.permission.INTERNET" /> , Without it, the Android app cannot access the network at all, so all requests would fail with “Failed to fetch / SocketException”.

5. 1-User input in Flutter
   2-Flutter sends JSON to Django
   3-Django receives & processes
   4-Flutter receives response and reacts
   5-JSON -> Dart model -> UI

6. Registration
      1-User opens the Register page in Flutter and fills username + passwords.
      2-Flutter calls CookieRequest.postJson to /auth/register/ with JSON Format
      3-in authentication/views.py, parses request.body, reates a new Django User ,Returns JSON with status and message.
      4-SnackBar Notification of Success
   Login
      1-enters username + password.
      2-Flutter calls a request login
      3-in authentication/views.py: check credentials(Uses authenticate) ,If valid, calls auth_login(request, user) which creates a session and sets the sessionid cookie ,Returns JSON with status, username, message.
      4-CookieRequest stores the cookies from the response.
      5-Flutter: if it successfull checking the status, Uses Navigator.pushReplacement to go to HomePage, every page that uses CookieRequest sends the same sessionid.
   Logout
      1- On pressed logout button, Flutter calls: await request.logout("http://localhost:8000/auth/logout/");
      2-Django’s logout view (authentication/views.py):Calls auth_logout(request) which clears the session, Returns JSON with status and message.
      3-CookieRequest.logout clears stored cookies on Flutter side.
      4-Flutter Shows a SnackBar Notification to show that you logged out
      5-Uses Navigator.pushReplacement to go back to the LoginPage

checklist implementation:

Django Startapp Authentication

Set up the Login/Logout/Register functions in authentication/views.py

Added the URLs for Login/Logout/Register in authentication/urls.py

Added the allowed host ports in main/settings.py

Added CORS configuration and the CORS middleware in main/settings.py

Installed django-cors-headers and added it to requirements.txt

Added the authentication app and URLs in main/urls.py

Added login.dart and register.dart in Flutter

Ran the command flutter pub add provider and flutter pub add pbp_django_auth

Added the imports:
   import 'package:pbp_django_auth/pbp_django_auth.dart';
   import 'package:provider/provider.dart';

Created the CookieRequest request = CookieRequest(); instance

Generated Dart models using QuickType from the JSON data of the Django app

Created dedicated Dart files for the models

Added the HTTP dependency using flutter pub add http

Added Internet access permission in android/app/src/main/AndroidManifest.xml

Added the backend access for creating and listing products (both all and user-owned) in main/views.py

Added the Dart file that shows the list of all products from the JSON endpoint

Added the Dart file that shows the list of user-owned products from the JSON endpoint

Added the Dart file that shows details of products from the JSON endpoint
  
   
