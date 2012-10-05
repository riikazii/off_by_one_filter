<?php
// Accept an image that is 512x512, and return the previous image that has been given to it.
// By Matt Mets, 2012

// Spit out the contents of the uploads file.
$lines = file("uploads.txt");

// Loop through our array, show HTML source as HTML source; and line numbers too.
foreach ($lines as $line_num => $filename) {
        echo "Image #{$line_num} : " . "<a href= " . $filename . ">" . $filename . " </a> <br />";
}

?>

