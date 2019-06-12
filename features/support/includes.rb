require 'logger'
require 'english'       # this is for speaking built-in variable names e.g. $CHILD_STATUS instead of $?
require 'featuremap'    # include the featuremap main class
require 'nokogiri'      # include xml creation and validation lib
require 'fileutils'     # for setting access rights to test_data files and dirs
require 'open3'         # to read from stderr
