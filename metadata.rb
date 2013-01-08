maintainer       "Paul Welch"
maintainer_email "paul@pwelch.net"
license          "Apache 2.0"
description      "Installs/Configures backup"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{build-essential}.each do |cb|
  depends cb
end

suggests "cron"
suggests "ruby_installer"
