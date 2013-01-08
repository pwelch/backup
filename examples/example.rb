#
# Cookbook Name:: backup
# Recipe:: example
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "backup"

backup_generate_model "pg" do
  description "backup of postgres"
  backup_type "database"
  database_type "PostgreSQL"
  split_into_chunks_of 2048
  store_with(x {
    "engine" => "S3",
    "settings" => {
      "s3.access_key_id" => "sample",
      "s3.secret_access_key" => "sample",
      "s3.region" => "us-east-1",
      "s3.bucket" => "sample",
      "s3.path" => "/", "s3.keep" => 10 }
  })
  options({
    "db.name" => "\"postgres\"",
    "db.username" => "\"postgres\"",
    "db.password" => "\"korma\"",
    "db.host" => "\"localhost\""
  })
  mailto "sample@example.com"
  action :backup
end

backup_generate_model "mongodb" do
  description "something"
  backup_type "database"
  database_type "MongoDB"
  split_into_chunks_of 2048
  store_with({
    "engine" => "S3",
    "settings" => {
      "s3.access_key_id" => "sample",
      "s3.secret_access_key" => "sample",
      "s3.region" => "us-east-1",
      "s3.bucket" => "sample", "s3.path" => "/",
      "s3.keep" => 10 }
  })
  options({
    "db.host" => "\"localhost\"",
    "db.lock" => true})
  mailto "sample@example.com"
  action :backup
end

backup_generate_model "archive" do
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
      "s3.path" => "/", "s3.keep" => 10 }
  })
  options({
    "add" => ["/home/","/etc/"],
    "exclude" => ["/etc/init"],
    "tar_options" => "-p"})
  mailto "sample@example.com"
  action :backup
end

