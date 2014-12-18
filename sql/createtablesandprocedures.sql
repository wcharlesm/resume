CREATE TABLE `certification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(75) NOT NULL,
  `organization` varchar(75) NOT NULL,
  `datereceived` datetime NOT NULL,
  `personid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='linked to skills through a mapping table';

CREATE TABLE `company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(75) NOT NULL,
  `startdate` datetime NOT NULL,
  `enddate` datetime DEFAULT NULL,
  `personid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='company information that links to a personid of someone that worked there';

CREATE TABLE `person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Name and contact information';

CREATE TABLE `position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(75) NOT NULL,
  `startdate` datetime NOT NULL,
  `enddate` datetime DEFAULT NULL,
  `description` varchar(511) DEFAULT NULL,
  `companyid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='position a person worked linked to the companyid of where they worked this position';

CREATE TABLE `responsibility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `positionid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='responsibility has a description and links to a position';

CREATE TABLE `skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `skill` varchar(45) NOT NULL,
  `skilllevel` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

CREATE TABLE `skillmap` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `origintype` int(11) NOT NULL DEFAULT '0' COMMENT '0 = person, 1 = position, 2 = responsibility, 3 = certification',
  `originid` int(11) NOT NULL,
  `skillid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='maps skills to various other table, ie position/responsibility/certification/person.  The table to map to is determined by the origintype column.';

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_resumebypersonid`(IN pid INT)
BEGIN

	SELECT person.name AS personname, person.email, person.phone, 
			company.name AS companyname, company.startdate AS companystartdate, company.enddate as companyenddate,
			position.name AS positionname, position.startdate AS positionstartdate, position.enddate AS positionenddate, position.description AS positiondescription,
            responsibility.description AS responsibilitydescription
    FROM 
		((person LEFT JOIN company ON person.id = company.personid)
        LEFT JOIN position ON company.id = position.companyid)
        LEFT JOIN responsibility ON position.id = responsibility.positionid
	WHERE person.id = pid
    ORDER BY `position`.`startdate` DESC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_skillsbypersonid`(IN pid INT)
BEGIN
    
    
    SELECT skill.skill AS skillname, NULL AS companyname, NULL AS positionname, NULL AS certificationname, NULL AS responsibilitydescription
    FROM skill RIGHT JOIN skillmap ON skill.id = skillmap.skillid
    WHERE skillmap.originid = pid AND skillmap.origintype = 0
    UNION
    SELECT skill.skill AS skillname, company.name AS companyname, position.name AS positionname, NULL AS certificationname, NULL AS responsibilitydescription
    FROM skill RIGHT JOIN
			(skillmap RIGHT JOIN 
				(position RIGHT JOIN company ON position.companyid = company.id) 
			ON skillmap.originid = position.id)
		ON skill.id = skillmap.skillid
    WHERE company.personid = pid AND skillmap.origintype = 1
	UNION 
    SELECT skill.skill AS skillname, company.name AS companyname, position.name AS positionname, 
			responsibility.description AS responsibilitydescription, NULL AS certificationname
    FROM skill RIGHT JOIN
			(skillmap RIGHT JOIN 
				responsibility RIGHT JOIN 
					(position RIGHT JOIN company ON position.companyid = company.id) 
               ON position.id = responsibility.positionid
			ON skillmap.originid = position.id)
		ON skill.id = skillmap.skillid
    WHERE company.personid = pid AND skillmap.origintype = 2
	UNION
    SELECT skill.skill AS skillname, NULL AS companyname, NULL AS positionname, certification.name AS certificationname, NULL AS responsibilitydescription
    FROM skill RIGHT JOIN
			(skillmap RIGHT JOIN certification ON skillmap.originid = certification.id)
		ON skill.id = skillmap.skillid
    WHERE certification.personid = pid AND skillmap.origintype = 3;
    
END$$
DELIMITER ;





