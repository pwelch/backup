Description
===========

This cookbook aims to provide a foundation for you to **backup** your infrastructure.  This cookbook helps you deploy the [backup](https://github.com/meskyanichi/backup) gem and generate the models to back up.

This is a fork. For other versions of the cookbook, see the LICENSE.md
file.

Requirements
============

Ruby installed either in the system or via omnibus

Resources and Providers
=======================

This cookbook provides three resources and corresponding providers.

`install.rb`
-------------

Install or Remove the backup gem with this resource.

Actions:

* `install` - installs the backup gem
* `remove` - removes the backup gem

Attribute Parameters:

* `version` - specify the version of the backup gem to install

`generate_config.rb`
-------------

Generate a configuration file for the backup gem with this resource.

Actions: 

* `setup` - sets up a basic config.rb for the backup gem
* `remove` - **removes the base directory for the backup gem** and everything underneath it.

Attribute Parameters:

* `base_dir` - String - default to `/opt/backup`
* `encryption_password` - String - Provide a passphrase for [Encryption](https://github.com/meskyanichi/backup/wiki/Encryptors) - default of `nil`

`generate_model.rb`
-------------

Generates a model file for the backup gem and creates a crontab entry.

Actions:

* `backup` - Generate a model file 
* `disable` - Disable the scheduled cron for the model
* `remove` - Remove the model from the system and the scheduled cron.


Attribute Parameters:

* `base_dir` - String - default to `/opt/backup`   
* `split_into_chunks_of` - Fixnum - defaults to 250  
* `description` - String - Description of backup   
* `backup_type` - String - Type of backup to perform.  Current options supported are `{database|archive}`  
* `store_with` - Hash - Specifies how to store the backups  
* `database_type` - String - If backing up a database, what [Type](https://github.com/meskyanichi/backup/wiki/Databases) of database is being backed up.    
* `hour` - String - Hour to run the scheduled backup - default - `1`  
* `minute` - String - Minute to run the scheduled backup - default - `*`  
* `day` - String - Day to run the scheduled backup - default - `*`  
* `weekday` - String - Weekday to run the scheduled backup - default - `*`  
* `mailto` - String - Enables the cron resource to mail the output of the backup output.  


Usage
=====

There are infinite ways you can implement this cookbook into your environment in theory.  An working example might be:

* Backing up MongoDB to S3
  1. Ensure your mongodb cookbook depends on the backup cookbook
  2. Add the following to your mongodb cookbook

  ```ruby
        include_recipe 'backup'
 
        backup_generate_model "mongodb" do  
          description "Our shard"  
          backup_type "database"  
          database_type "MongoDB"  
          split_into_chunks_of 2048  
          store_with({
            "engine" => "S3",
            "settings" => { 
              "s3.access_key_id" => "example", 
              "s3.secret_access_key" => "sample",
              "s3.region" => "us-east-1", 
              "s3.bucket" => "sample", 
              "s3.path" => "/",
              "s3.keep" => 10 } 
          })  
          options({
            "db.host" => "\"localhost\"", 
            "db.lock" => true})  
          mailto "some@example.com"  
          action :backup  
        end  
  ```

* Backing up PostgreSQL to S3
  1. Ensure your postgresql cookbook depends on the backup cookbook
  2. Add the following to your postgresql cookbook
  
  ```ruby
        include_recipe 'backup'
        
        backup_generate_model "pg" do  
          description "backup of postgres"  
          backup_type "database"  
          database_type "PostgreSQL"  
          split_into_chunks_of 2048  
          store_with({
            "engine" => "S3",
            "settings" => {
              "s3.access_key_id" => "sample", 
              "s3.secret_access_key" => "sample",
              "s3.region" => "us-east-1",
              "s3.bucket" => "sample", 
              "s3.path" => "/", 
              "s3.keep" => 10 } 
          })
          options({
            "db.name" => "\"postgres\"",
            "db.username" => "\"postgres\"",
            "db.password" => "\"somepassword\"",
            "db.host" => "\"localhost\"" })  
          mailto "sample@example.com"  
          action :backup  
        end
  ```

* Backing up Files to S3
  1. Ensure the cookbook are updating depends on the backup cookbook.
  2. Add the following to that cookbook
 
  ```ruby
       include_recipe 'backup'

        backup_generate_model "home" do  
          description "backup of /home"  
          backup_type "archive"  
          split_into_chunks_of 250  
          store_with({
            "engine" => "S3",
            "settings" => { 
              "s3.access_key_id" => "sample", 
              "s3.secret_access_key" => "sample", 
              "s3.region" => "us-east-1", 
              "s3.bucket" => "sample", 
              "s3.path" => "/", 
              "s3.keep" => 10 } 
          })  
          options({
            "add" => ["/home/","/root/"], 
            "exclude" => ["/home/tmp"], 
            "tar_options" => "-p"
          })  
          mailto "sample@example.com"  
          action :backup  
        end
  ```  

* There is no technical reason you cannot load more of this code in via an `role` or an `data bag` instead.

License and Author
==================

See LICENSE.md

Special Credit and Thanks
=========================

Thank you to the other versions of this cookbook that this was forked
from.

* [damm](https://github.com/damm/backup)
* [Heavy Water](hw-ops.com) for contributing the original [backup](https://github.com/hw-cookbooks/backup) cookbook.  
