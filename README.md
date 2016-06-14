# SCTableView
  This is an encapsulation for UITableView. it hide the cellRegiter, datasource and delegate method, just expose and gather those key method. 
####Who is behind SCTableView
  just a e-mail address: 894054389@qq.com.
####Usage
  The TableView's usage is simple, one method for initialization, one method for cell choice(this method must use before datasource method), one method for cell response, one method for datasource and section header and section footer, one method for cell edit.if you you are gonging to create UITableViewCell, youneed to import the category "UITableViewCell+BaseConfiguration.h" of UITableViewCell and confirm the interface "SCBaseTableCellInterFace", then immplement relate method. As for the details, download a copy of code, you will see.
#####Version History
  - March   2016: version 1.0
  - June    2016: version 1.1 (The design pattern for UITableViewCell's usage change form generalization to composition)
  
