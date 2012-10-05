<?php
// Accept an image that is 512x512, and return the previous image that has been given to it.
// By Matt Mets, 2012
// 
// Basic idea from these places:
// Image uploading: http://www.w3schools.com/php/php_file_upload.asp
// file locking: http://php.net/manual/en/function.flock.php

$allowedExts = array("jpg", "jpeg", "gif", "png");
$extension = pathinfo($_FILES["file"]["name"], PATHINFO_EXTENSION);
$size = getimagesize($_FILES["file"]["tmp_name"]);

// echo $size[0] . " " . $size[1] . " " . $_FILES["file"]["type"] . " " . $_FILES["file"]["size"] . " " . $_FILES["file"]["name"];

if ((($_FILES["file"]["type"] == "image/gif")
|| ($_FILES["file"]["type"] == "image/jpeg")
|| ($_FILES["file"]["type"] == "image/png")
|| ($_FILES["file"]["type"] == "image/pjpeg"))
&& ($_FILES["file"]["size"] < 400000)
&& in_array($extension, $allowedExts)
&& ($size[0] == 512)
&& ($size[1] == 512))
  {
  if ($_FILES["file"]["error"] > 0)
    {
    echo "ERROR Return Code: " . $_FILES["file"]["error"] . "<br />";
    }
  else
    {
    $new_name= "upload/" . basename($_FILES["file"]["tmp_name"]) . "." . pathinfo($_FILES["file"]["name"], PATHINFO_EXTENSION);

//    echo "Upload: " . $_FILES["file"]["name"] . "<br />";
//    echo "Type: " . $_FILES["file"]["type"] . "<br />";
//    echo "Size: " . ($_FILES["file"]["size"] / 1024) . " Kb<br />";
//    echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br />";

    if (file_exists($new_name))
      {
      echo $new_name . "ERROR already exists. ";
      }
    else
      {
      move_uploaded_file($_FILES["file"]["tmp_name"],
      $new_name);

      // Now, try to append it to our list
      $fp = fopen("uploads.txt", "a");

      if (flock($fp, LOCK_EX))
        {  // acquire an exclusive lock
        $last_name = `tail -n 1 uploads.txt`;

        fwrite($fp, $new_name . "\n");
        fflush($fp);            // flush output before releasing the lock
        flock($fp, LOCK_UN);    // release the lock

//        echo "Stored in: " . $new_name . "<br />";
//        echo "<img src=" . $new_name . " />" . "<br />";


        if ($last_name <> '')
          {
          echo "SUCCESS " . $last_name . "<br />";
//        echo "<img src=" . $last_name . " />" . "<br />";
          }
        else
          {
          echo "FAILURE no file to return";
          }

        }
      else
        {
        echo "ERROR Couldn't get the lock!";
        }

      fclose($fp);

      }
    }
  }
else
  {
  echo "ERROR Invalid file";
  }
?>

