.. PhysioZoo documentation master file, created by
   sphinx-quickstart on Thu May 17 12:31:38 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

PhysioZoo documentation
=========================

.. include:: sections/intro.rst

.. toctree::
   :glob:
   :maxdepth: 2
   :caption: Tutorials
   
   sections/tutorials/installation.rst
   sections/tutorials/electrorecord.rst
   sections/tutorials/peakdetection.rst
   sections/tutorials/preprocessing.rst   
   sections/tutorials/hrvanalysis.rst
   sections/tutorials/sqanalysis.rst
   sections/tutorials/pzloader.rst
   sections/tutorials/pzformats.rst
   sections/tutorials/configfiles.rst

mhrv toolbox documentation
==============================

.. mdinclude:: mhrv/sections/intro.md

.. toctree::
   :maxdepth: 2
   :caption: Working with the toolbox

   mhrv/sections/getting_started.md
   
.. toctree::
   :maxdepth: 2
   :caption: mhrv API Reference

   sections/mhrv/mhrv.rst

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
