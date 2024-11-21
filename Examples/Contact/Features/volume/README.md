# VolumeRendering

VolumeData node
and DICOMVolumeTexture

ask for special build with DICOM (DCM) support

EXTERNPROTO DICOMTexture[
	exposedField SFNode metadata
	exposedField MFString url
	exposedField SFInt32 selected
	eventOut SFBool isLoaded
	exposedField MFNode texture
	exposedField SFNode volumeTexture
	exposedField SFNode transferTexture
	exposedField SFVec3f volumeCenter
	exposedField SFVec3f volumeSize
	exposedField SFVec3f volumeSizePixel
	exposedField SFNode volumeGeometry
	exposedField SFInt32 volumeStyle
	exposedField SFBool computeGradient
	eventOut SFBool hasGradient
	exposedField SFInt32 numSlices
	exposedField SFVec2f sliceRange
	exposedField MFVec4f colorCurvePoints
	exposedField MFVec2f alphaCurvePoints
	exposedField MFString parameter
	exposedField SFNode textureProperties
	]
["urn:inet:bitmanagement.de:node:DICOMTexture","http://www.bitmanagement.de/vrml/protos/nodes.wrl#DICOMTexture","nodes.wrl#DICOMTexture"]


