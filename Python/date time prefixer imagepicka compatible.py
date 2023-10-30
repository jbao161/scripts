import os # figure out path names
import sys # pass the image files as input parameters
import datetime # prefix the filename with current date and time
import ntpath # find the base filename 
import re # regex to rename file

# prefix files with date and time
# only renames pictures and video files
# does not rename folders
# truncates filename if excedes windows max characters
# usage: script.py target_file_or_folder or drop and drop files or folders onto the script file
# author: Jonathan Bao jbao161@gmail.com

def replace_right(source, target, replacement, replacements=None):
    return replacement.join(source.rsplit(target, replacements))

inputfiles = sys.argv[1:]
# specifies the file types to rename
regex_img = re.compile(".(?:jpg|jpeg|gif|png|mp4|avi|flv|mpg|wmv|wma)(?!.)$", flags=re.IGNORECASE)
n_renamed = 0
n_notrenamed = 0
n_truncated = 0
n_padded = 0
n_underscore = 0 
n_shortened = 0
n_imagepickadefault = 0
filename_maxlength = 196
filename_extensionlength = -4
for inputfile in inputfiles:
    listing = {inputfile}
    if os.path.isdir(inputfile):
        print ('*' * 8)
        print("Folder detected. Opening non-folder files in " + inputfile)
        print ('*' * 8)
        listing = [os.path.join(inputfile, f) for f in os.listdir(inputfile) if os.path.isfile(os.path.join(inputfile, f))]

    for infile in listing:
        print ("Current file is: " + ntpath.basename(infile))
        if re.match(r"^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{6} .*", ntpath.basename(infile)):
            # do nothing. file is already prefixed with a date and time format
            print ("No renaming required. (File already has datetime prefix.)")
            n_notrenamed+=1
        elif re.search(regex_img, infile)is not None:
            # if file extension matches a specified type, rename it
            output_filename = datetime.datetime.now().strftime('%Y_%m_%d_%H%M%S%f')[:-6] #-6 for seconds. -3 for milliseconds
            output_filename += " " + ntpath.basename(infile)
            # if impagepicka default formatting change dashes to underscores
            if re.match(r"^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2} [0-9]{2} [0-9]{2}.*", ntpath.basename(infile)):
                print ("Converting default imagepicka datetime.")
                n_imagepickadefault +=1
                text_after = re.sub(r"^([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}) ([0-9]{2}) ([0-9]{2})(.*)", r"\1_\2_\3\4\5\6\7", ntpath.basename(infile)[:19])
                output_filename = text_after  + " " + ntpath.basename(infile)[20 : ] 
            # if file is missing one digit just pad a zero instead of another prefix
            elif re.match(r"^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{5}[^0-9].*", ntpath.basename(infile)):
                print ("Padding zero to incorrectly formatted datetime.")
                n_padded +=1
                output_filename = ntpath.basename(infile)[ : 16] + "0" + ntpath.basename(infile)[16 : ] 
           # if file has is missing an underscore after the day
            elif re.match(r"^[0-9]{4}_[0-9]{2}_[0-9]{8}.*", ntpath.basename(infile)):
                print ("Inserting underscore.")
                n_underscore +=1
                text_after = re.sub(r"^([0-9]{4}_[0-9]{2}_[0-9]{2})([0-9]{6})[? ]*(.*)", r"\1_\2 \3", ntpath.basename(infile))
                output_filename = text_after 
            # if file has too many digits, shorten them
            if re.match(r"^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{7}.*", ntpath.basename(infile)):
                print ("Shortening digits.")
                n_shortened +=1
                text_after = re.sub(r"(^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{6})[0-9]*[? ]*(.*)", r"\1 \2", ntpath.basename(infile))
                output_filename = text_after 
            outfile = replace_right(infile, ntpath.basename(infile), output_filename, 1)
            outfile_truncated = outfile
            # if filename too long, truncate it
            if len(outfile)>filename_maxlength:
                outfile_truncated = outfile[:filename_maxlength]+outfile[filename_extensionlength:]
                n_truncated +=1
                print ("Filename is being truncated to " + str(filename_maxlength - filename_extensionlength) + " characters")
            print ("Current output is: " + outfile_truncated)
            os.rename(infile, outfile_truncated)
            n_renamed +=1
        else:
            print("No renaming required. (Not a picture file)")
            n_notrenamed+=1
        print()
        
print (str(n_renamed) + " files renamed. " +str(n_truncated) + 
" of those were shortened to " + str(filename_maxlength - filename_extensionlength) + " characters. " 
+ str(n_renamed-n_padded -n_imagepickadefault - n_underscore - n_shortened) + " files added prefix. " 
+ str(n_imagepickadefault) + " files converted from imagepicka format. "
+ str(n_padded) + " files padded a zero. " 
+ str(n_underscore) + " files inserted underscore. " 
+ str(n_shortened) + " files date shortened. " 
+ str(n_notrenamed) + " files skipped. " 
+ str(n_notrenamed+n_renamed) + " total files.")
input("Press enter to close program")