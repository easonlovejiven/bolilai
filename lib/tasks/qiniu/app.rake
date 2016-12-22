require "qiniu"
namespace :qiniu do
  desc 'download_barlar'
  task :download_barlar do
    system "#{File.dirname(__FILE__)}/lib/qshell qdownload 10 #{File.dirname(__FILE__)}/config/qdisk_down.conf"
  end
  desc 'upload_demo'
  task :upload_demo do
    system "#{File.dirname(__FILE__)}/lib/qshell qupload 10 #{File.dirname(__FILE__)}/config/qdisk_upload.conf"
  end

  desc 'set qiniupfop'
  task :qiniupfop do
    Qiniu.establish_connection! :access_key => "zVJAduNOLHHJem6ZGu-3Lm7kx_Q-o2epBPE01zGK",
                                :secret_key => "BHREjhlN15sbK9ch1zh4n5RGdB7N_xXRvKPYfMoZ"
    fops="imageView2/2/w/900/q/85"
    pfop=Qiniu::Fop::Persistance::PfopPolicy.new("weimall-demo", "", fops, "")
    pfop.force!
    result=Qiniu::Fop::Persistance.pfop(pfop)
    puts "#####{result}"
    # result = Timeout::timeout(30) { HTTParty.post(action, body: body, :headers => {'Content-type' => 'application/x-www-form-urlencoded'}) }
  end

  desc "qrsctl style"
  task :syn_style do
    require "qiniu"
    # Qiniu.establish_connection! :access_key => "zVJAduNOLHHJem6ZGu-3Lm7kx_Q-o2epBPE01zGK",
    #                             :secret_key => "BHREjhlN15sbK9ch1zh4n5RGdB7N_xXRvKPYfMoZ"
    # puts "xxxx",Qiniu.buckets
    qrsctl="#{File.dirname(__FILE__)}/lib/qrsctl"
    # system "qrsctl login zhangyun@richje.com Fuyue31102777"
    # result=system "qrsctl bucketinfo weimall"
    styles=JSON.parse '{
      "big": "imageView2/2/w/900/q/85",
      "big1": "imageView2/1/w/600/h/600/q/85",
      "big800": "imageView2/1/w/800/h/800/q/85",
      "content": "imageView2/1/w/1178/q/85",
      "cover280": "imageView2/2/w/280/h/140/q/85",
      "cover320": "imageView2/2/w/320/q/85",
      "cover400": "imageView2/1/w/400/h/400/q/85",
      "m640": "imageView2/1/w/640/h/640/q/85",
      "medium": "imageView2/1/w/200/h/200/q/85",
      "thumb": "imageView2/1/w/100/h/100/q/85",
      "thumb220": "imageView2/1/w/200/h/200/q/85",
      "tiny": "imageView2/1/w/50/h/50/q/85"
    }'
    puts styles
    system "#{qrsctl} login sunyawei8@163.com 123456sun"
    # result=system "qrsctl bucketinfo weimall"
    styles.each do |key,value|
      # Qiniu.set_style("weimaill",key,value)
      system "#{qrsctl} style weimall-demo #{key} #{value}"
    end
  end
end
