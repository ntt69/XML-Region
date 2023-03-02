# XML-Region
Oracle APEX XML Region plugin

This plugin is used to display XML from database. It can be XML document stored into database or any other construct that maps to XML data type.

In order to select proper record for displaying, SQL query is supplied together with primary key value as page item. SQL query should return only one column and one row.

The XML structure is presented using combination of \<ul>, \<li> tags following natural tree structure of XML document.

It could be useful to display any kind of hierarchical data and complex structures, for example the SQL statement could run across several relation tables with master - master - detail structure wrap it into XML structure ready to be displayed with the plugin.

Additionally CSS styling can be applied through CSS attribute. Non terminal \<li> tags contain class attribute mapped from the name of original XML tag, making targeting of specific html areas easier.
