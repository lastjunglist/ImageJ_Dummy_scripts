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
    //  select which channel you want to process by specifying the name
		if (endsWith(currentImage_name, "ch00.tif")){
      //  convert greyscale image to binary
			setOption("BlackBackground", true);
			run("Convert to Mask");
      //  remove noise by setting outliers
			run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
			setAutoThreshold("Default dark no-reset");
		  //  run("Threshold...");
			//  setThreshold(255, 255);
			run("Convert to Mask");
      //  set the measurement to calculate the area of white
			run("Set Measurements...", "area limit redirect=None decimal=3");
      //  measure the area
			run("Measure");
			saveAs("tiff", output_dir+currentImage_name);
			run("Close All");
		}
	}
}
setBatchMode(false);
//save the results if access is permitted
saveAs("Results", output_dir);
