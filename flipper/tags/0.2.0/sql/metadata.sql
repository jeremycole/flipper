CREATE TABLE `masterpair` (
  `masterpair` varchar(20) NOT NULL default '',
  `name` varchar(20) NOT NULL default '',
  `value` blob NOT NULL,
  PRIMARY KEY  (`masterpair`,`name`)
);

CREATE TABLE `node` (
  `masterpair` varchar(20) NOT NULL default '',
  `node` varchar(20) NOT NULL default '',
  `name` varchar(20) NOT NULL default '',
  `value` blob NOT NULL,
  PRIMARY KEY  (`masterpair`,`node`,`name`)
);
