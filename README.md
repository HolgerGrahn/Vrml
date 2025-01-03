# Vrml
VRML, X3D, Media Demos and Scenes mainly for BSContact 3D Player

Holger Grahn

## Introduction
Bitmanagement BSContact Player is a 3D Engine supporting DirectX9, DirectX11 and OpenGL
It is based on the Web3D VRML Standard

Here is a set of examples and demos for specific BSContact features

Tthe BSContact Player is available 
https://www.bitmanagement.de/en/products/interactive-3d-clients/bs-contact

BSContact Stereo adds support for 
Stereo Rendering, Stereo Video Rendering, MultiView Display and VR Occulus Rift support 
https://www.bitmanagement.de/en/products/interactive-3d-clients/bs-contact-stereo

Input Formats are
WRL, X3D, OBJ, STL, PLY, Collada (DAE)
Texture Fomats are
jpeg, png, j2k, dds, bmp, tga, gif ..
Video Formats are based on DirectShow and installed codecs
avi, mpeg ...
3D Videos can be opened directly in different format like side by side, above-below etc
all 3D Files imported can be exported back as WRL, X3D ...

More Bitmanagement developer info on 
http://sdk.bitmanagement.de/
https://www.bitmanagement.de/developer/index.html

## General VRML / X3D information / Resources
https://www.web3d.org/what-x3d-graphics

VRML 97  ISO/IEC 14772-1:1997 - The Virtual Reality Modeling Language
https://www.bitmanagement.de/developer/spec/vrml97/index.html
https://www.bitmanagement.de/developer/spec/vrml97specification.pdf
https://www.bitmanagement.de/developer/spec/vrmlscript/vrmlscript.html

X3D ISO/IEC 19775-1:2013
https://www.web3d.org/documents/specifications/19775-1/V3.3/

## Launching the BSContact Player

Because drop of support for native plugins in Webbrowsers like Google Chrome, Microsoft Edge, Firefox
you would need to load url's in the BSContact Player->File Open Command.

Microsoft Internet Explorer supported the hosting of the Active X compononent BSContactVmrl.ocx,
so there are many examples using the WebBrowser HTML integration.
A workaround solution to open an url in BSContact is by simply clicking in a WebBrower, is to create a BSURL file.
Its the same fromat as the Windows URL InternetShortCut file, but bsurl is associated with BSContact.exe


Eaxmple bsurl file, save as  textfile with .bsurl extension:
[InternetShortcut]
URL=https://www.bitmanagement.de/developer/contact/examples/texcoordGen/venus_gradient.wrl

Examples:
https://github.com/HolgerGrahn/Vrml/tree/main/Examples/bsurl

click on a file, use the GitHub download button, double click in  the download file to open BSContact.exe or drag the link into an open BSContact.

For the demos on this repositiory it might be easiest to download as ZIP.
OBJ files are are refering MTL and texuture files, this is not currently supported via HTTP download, so the folders need to be downloaded as zip.



Some older examples
https://home.snafu.de/hg/vrml/archive/

https://home.snafu.de/hg/ (mostly defunct links)






