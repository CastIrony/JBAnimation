JBAnimation
===========

JBAnimation is a framework I've built up over the past several years of doing animation on iOS. I've used it with UIViews, CALayers, OpenGL, and SceneKit, but it's flexible enough to work with pretty much any iOS animation library.


JBDisplayContainer
------------------

The most important part of JBAnimation is the JBDisplayContainer collection class. JBDisplayContainer is essentially an ordered dictionary, allowing key-based access and fast sequential enumeration of items, and it has several useful features:

1. It allows you to define a mapping between model objects and display items.
2. It stores up to one live display item per key, but an unlimited number of dying and dead display items.
3. When given an array of models, it figures out which are new and need to be animated in, which existing display items aren't present and need to be animated out, and any reordering. After making these changes, it calls a layout delegate which is in charge of applying a layout to the new set of display items.
