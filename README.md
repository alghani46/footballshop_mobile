# footballshop_mobile
footballshop_mobile


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


3.MaterialApp, Creates a root navigator and route table
Enables Material components (Scaffold, AppBar, SnackBar)

4. -StatelessWidget
   Once created, its properties cannot change
   does not have a state that can be updated during its lifetime
   ommonly becomes the root
   
   -StatefulWidget
   object that can change over time.
   rebuilds when data changes
   handle user interaction, animations


5.BuildContext is an object that serves as a handle to the location of a widget within the widget tree. 
It represents the context in which a specific widget is built and exists.
Every build method receives a BuildContext corresponding to the current widget’s position.
(showing a SnackBar must use a context that has a ScaffoldMessenger above it)


6. Hot reload
   Injects updated source code into the running Dart VM and rebuilds the widget tree.
   certain type/structural changes might not fully apply

   Hot restart
   Restarts the app without a full device process kill, clearing the Dart VM state,Re‑runs main(); all State objects are recreated.
   





   
