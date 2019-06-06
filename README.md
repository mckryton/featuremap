# featuremap

This script converts Gherkin feature files into a [Freemind mindmap](http://freemind.sourceforge.net/wiki/index.php/Main_Page).

![sample featuremap](doc/img/featuremap_rb.jpeg)

## Usage
featuremap [options] features_dir [mindmap_file]

|parameter|description|
|---------|-----------|
|features_dir|This is the root directory containing the Gherkin feature files. Typically named "features".|
|mindmap_file|The name of the mindmap file created by featuremap. If omitted **featuremap** writes to stdout. (*not yet implemented*)|

### Options

|parameter|description|
|---------|-----------|
|-v, --verbose| show log messages (disabled by default if **featuremap** writes to stdout)|
