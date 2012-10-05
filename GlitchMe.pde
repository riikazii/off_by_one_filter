import javax.imageio.*;
import java.awt.image.BufferedImage;

// Off-by-one glitch filter.
// By Matt Mets
//
// Uses code from these here examples:
// uploading an image to http server: http://wiki.processing.org/w/Saving_files_to_a_web-server
// implement bufferImage: https://github.com/jywarren/spectral-workbench/blob/master/spectrometry_kit/src/lib/bufferImage.java


PImage glitchMe(PImage input) {
  String response;
  response = postData("title","jpg","folder", bufferImage(input),true);
  
  if(response.startsWith("SUCCESS ")) {
    return(loadImage(url + response.substring(8), "jpg"));
  }
  
  // nothing to return, eh? bummers.
  return(input);
}


String url = "http://cibomahto.com/glitchfilter/";
 
String postData(String title, String ext, String folder,  byte[] bytes, boolean popup)
{
  try{
    URL u = new URL(url+"upload_file.php");
    URLConnection c = u.openConnection();
    // post multipart data
 
    c.setDoOutput(true);
    c.setDoInput(true);
    c.setUseCaches(false);
 
    // set request headers
    c.setRequestProperty("Content-Type", "multipart/form-data; boundary=AXi93A");
 
    // open a stream which can write to the url
    DataOutputStream dstream = new DataOutputStream(c.getOutputStream());
 
    // write content to the server, begin with the tag that says a content element is comming
    dstream.writeBytes("--AXi93A\r\n");
 
    // discribe the content
    dstream.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=capture.jpg \r\nContent-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n");
    dstream.write(bytes,0,bytes.length);
 
    // close the multipart form request
    dstream.writeBytes("\r\n--AXi93A--\r\n\r\n");
    dstream.flush();
    dstream.close();
 
    // read the output from the URL
    try{
      BufferedReader in = new BufferedReader(new InputStreamReader(c.getInputStream()));
      String sIn = in.readLine();
      boolean b = true;
      while(sIn!=null){
        if(sIn!=null){
          // Only return the first line
          return sIn;
        }
        sIn = in.readLine();
      }
    }
    catch(Exception e){
      e.printStackTrace();
    }
  }
 
  catch(Exception e){ 
    e.printStackTrace();
  }
  
  return "FAILURE";
}


byte[] bufferImage(PImage srcimg) {
  ByteArrayOutputStream out = new ByteArrayOutputStream();
  //BufferedImage img = new BufferedImage(srcimg.width, srcimg.height, 2);
  BufferedImage img = new BufferedImage(srcimg.width, srcimg.height, BufferedImage.TYPE_INT_ARGB);
  img = (BufferedImage) createImage(srcimg.width,srcimg.height);
  img.setRGB(0, 0, srcimg.width, srcimg.height, srcimg.pixels, 0, srcimg.width);
 
  try {

    // http://helpdesk.objects.com.au/java/how-do-i-convert-a-java-image-to-a-png-byte-array
      // http://docs.oracle.com/cd/E17802_01/products/products/java-media/jai/forDevelopers/jai-apidocs/com/sun/media/jai/codec/PNGEncodeParam.html
      // also read this: http://www.sussmanprejza.com/ar/card/DataUpload.java
    // PNG encoding goes here:
   
     ImageIO.write(img, "JPG", out);

  } catch (FileNotFoundException e) {
    println(e);
  } catch (IOException ioe) {
    println(ioe);
  }
  return out.toByteArray();
}
