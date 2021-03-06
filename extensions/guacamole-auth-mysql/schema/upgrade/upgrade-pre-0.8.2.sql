
--
-- Table of connection groups. Each connection group has a name.
--

CREATE TABLE `guacamole_connection_group` (

  `connection_group_id`   int(11)      NOT NULL AUTO_INCREMENT,
  `parent_id`             int(11),
  `connection_group_name` varchar(128) NOT NULL,
  `type`                  enum('ORGANIZATIONAL',
                               'BALANCING') NOT NULL DEFAULT 'ORGANIZATIONAL',


  PRIMARY KEY (`connection_group_id`),
  UNIQUE KEY `connection_group_name_parent` (`connection_group_name`, `parent_id`),

  CONSTRAINT `guacamole_connection_group_ibfk_1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Changes to connection table to support grouping.
--

ALTER TABLE `guacamole_connection` ADD COLUMN `parent_id` int(11) AFTER `connection_name`;

ALTER TABLE `guacamole_connection` DROP INDEX `connection_name`;
ALTER TABLE `guacamole_connection` ADD UNIQUE KEY `connection_name_parent` (`connection_name`, `parent_id`);

ALTER TABLE `guacamole_connection` ADD CONSTRAINT `guacamole_connection_ibfk_1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE;

--
-- Table of connection group permissions. Each group permission grants a user
-- specific access to a connection group.
--

CREATE TABLE `guacamole_connection_group_permission` (

  `user_id`             int(11) NOT NULL,
  `connection_group_id` int(11) NOT NULL,
  `permission`          enum('READ',
                             'UPDATE',
                             'DELETE',
                             'ADMINISTER') NOT NULL,

  PRIMARY KEY (`user_id`,`connection_group_id`,`permission`),

  CONSTRAINT `guacamole_connection_group_permission_ibfk_1`
    FOREIGN KEY (`connection_group_id`)
    REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE,

  CONSTRAINT `guacamole_connection_group_permission_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `guacamole_user` (`user_id`) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `guacamole_system_permission` MODIFY `permission` 
    enum('CREATE_CONNECTION',
         'CREATE_CONNECTION_GROUP',
         'CREATE_USER',
         'ADMINISTER') NOT NULL;
