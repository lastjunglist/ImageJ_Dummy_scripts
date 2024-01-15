// The piece for batch processing of the whole folder I borrowed from kind romainGuiet and his split_channels.ijm, thank you a lot!

// ask user to select a folder
dir = getDirectory("Select A folder");

// get the list of files (& folders) in it
fileList = getFileList(dir);

// prepare a folder to output the images
output_dir = dir + File.separator + "output" + File.separator ;

File.makeDirectory(output_dir);

//activate batch mode
setBatchMode(true);

// LOOP to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
	// define the "path" 
	// by concatenation of dir and the i element of the array fileList
	current_imagePath = dir+fileList[i];
	// check that the currentFile is not a directory
	if (!File.isDirectory(current_imagePath)){
		open(current_imagePath);
		currentImage_name = getTitle();
		selectWindow(currentImage_name);
		// convert from grayscale to RGB
		run("RGB Color");
		// split the channels
		run("Make Composite");
		run("Split Channels");
		// select the channel you are interested in (C2 is green)
		selectWindow("C2-" + currentImage_name);
		// optional - enhance brightness and contrast
		run("Brightness/Contrast...");
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
		run("Close");
		// save the enhanced image and close everything else
		saveAs("tiff", output_dir+currentImage_name);
		run("Close All");
	}
}
setBatchMode(false);
