
java.io.File folder = new java.io.File(dataPath("../../data"));
 
// list the files in the data folder
String[] filenames = folder.list();
 
// get and display the number of jpg files
println(filenames.length + " files in specified directory");
 
// display the filenames
for (int i = 0; i < filenames.length; i++) {
 if(filenames[i].indexOf(".png") > -1 && filenames[i].indexOf("_readed") == -1){println(filenames[i]);}
  
}
exit();
