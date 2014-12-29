require "language_pack/java"
require "fileutils"

module LanguagePack
  class Tuscany2 < Java
    include LanguagePack::PackageFetcher
    
    TUSCANY_VERSION = "tuscany-2.0.1".freeze
    TUSCANY_PACKAGE = "tuscany-2.0.1.tar.gz".freeze
    TUSCANY_DOWNLOAD = "http://114.212.87.52:8080/#{TUSCANY_PACKAGE}"
    
    def self.use?
      #File.exists?("")
      Dir.glob("**/*.jar").any?
    end
    
    def name
      "Tuscany 2.0"
    end
    
   
    def compile
      Dir.chdir(build_path) do
        install_java
        install_tuscany
       # remove_tuscany_files
        #move_tuscany_to_root
        
        setup_profiled
        setup_profiled_tuscany
      end
    end
    
    def tuscany_dir
      "tuscany"
      #".tuscany"
    end
    
    def install_tuscany
      FileUtils.mkdir_p tuscany_dir
      tuscany_tarball = "#{tuscany_dir}/#{TUSCANY_PACKAGE}"
      download_tuscany tuscany_tarball
      puts "Unpacking Tuscany to #{tuscany_dir}"
      
      run_with_err_output("tar zxf #{tuscany_tarball} -C #{tuscany_dir}")
      
      FileUtils.rm_rf tuscany_tarball
      puts "tuscanydir #{tuscany_dir}"
      puts "tuscanyverison #{TUSCANY_VERSION}"
      unless File.exists?("#{tuscany_dir}/#{TUSCANY_VERSION}/bin/tuscany.sh")
        puts "unable to retrieve Tuscany"
        exit 1
      end
    end
    
    
    
    def download_tuscany(tuscany_tarball)
      puts "Downloading Tuscany: #{TUSCANY_PACKAGE}"
      fetch_package TUSCANY_PACKAGE
      FileUtils.mv TUSCANY_PACKAGE , tuscany_tarball
    end
    
    def move_tuscany_to_root
      run_with_err_output("mv #{tuscany_dir}/#{TUSCANY_VERSION}/* . && rm -rf #{tuscany_dir}")  
    end
    
    
    
    def default_process_types
      {
        "web" => "tuscany.sh #{build_path}"
      }
    end 
      
      def setup_profiled_tuscany
        
        File.open("#{build_path}/.profile.d/tuscany.sh", "a") { |file| file.puts(bash_script_tuscany) }  
      
      end
      
      
      private 
    def bash_script_tuscany
      <<-BASH
#!/bin/bash
export TUSCANY_HOME="$HOME/#{tuscany_dir}/#{TUSCANY_VERSION}"
export PATH="$HOME/#{tuscany_dir}/#{TUSCANY_VERSION}/bin:$PATH" 
 
      BASH
    end
    
    end
  
end
