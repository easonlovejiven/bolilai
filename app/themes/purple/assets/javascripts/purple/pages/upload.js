$.fn.qiniuUpload = function (options) {
    options = $.extend({
        domain: $('#domain').val(),
        browse_button: $(this).attr("id"),
        $upload_group_warp: $('#uploadGroupWarp'),
        bucket: "images"
    }, options);
    var $progress_container = $('.upload_progress_warp', options.$upload_group_warp).attr('id');

    function guid() {
        var d = new Date().getTime();
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = (d + Math.random() * 16) % 16 | 0;
            d = Math.floor(d / 16);
            return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    }

    function handErr(msg) {
        $('.errors', options.$upload_group_warp).html('<span class="errors font-red">' + msg + '</span>')
    }

    $(".remove_btn", options.$upload_group_warp).on("click", function () {
        $(this).parents(".progressContainer").attr("data-destroy", 1).html("");
    });

    var uploader = Qiniu().uploader({
        runtimes: 'html5,flash,html4',
        browse_button: options.browse_button,
        dragdrop: true,
        chunk_size: '4mb',
        max_file_size: '35mb',
        flash_swf_url: "/Moxie.swf",
        uptoken_url: "/uploads/uptoken",
        domain: options.domain,
        multi_selection: options.max_files > 1,
        filters: [
            {title: "Image files", extensions: "jpg,png,jpeg"}
        ],
        auto_start: true,
        init: {
            'FilesAdded': function (up, files) {
                var max_files = options.max_files;
                if (up.files.length >= max_files) {
                    handErr("最多支持" + max_files + "个图片上传", "notice");
                }
                plupload.each(files, function (file) {
                    if (up.files.length > max_files) {
                        up.removeFile(file);
                    } else {
                        var progress = new FileProgress(file, $progress_container);
                        progress.setStatus("loading");
                    }
                });
                if (max_files <= 1) {
                    $("li:first", options.$upload_group_warp).remove();
                }
                $('#' + options.browse_button).attr('disabled', 'disabled')
            },
            'UploadProgress': function (up, file) {
                var progress = new FileProgress(file, $progress_container);
                var chunk_size = plupload.parseSize(this.getOption('chunk_size'));
                progress.setProgress(file.percent + "%", up.total.bytesPerSec, chunk_size);
            },
            'UploadComplete': function (up, files) {
                plupload.each(files, function (file) {
                    var progress = new FileProgress(file, $progress_container);
                    $('.remove_btn', progress.fileProgressWrapper).on("click", function (e, data, status, xhr) {
                        up.removeFile(progress.file);
                    })
                })
                $('#' + options.browse_button).removeAttr('disabled')
            },
            'FileUploaded': function (up, file, info) {
                var data = $.parseJSON(info);
                var key = data.key.replace("images/", "");
                $.post("/uploads.json", {
                    "upload[file_key]": key,
                    'upload[file_name]': file.name,
                    'upload[file_type]': file.type,
                    'upload[file_size]': file.size || 0
                }, function (data) {
                    var res = $.parseJSON(info);
                    var domain = "http://" + up.getOption('domain');
                    var progress = new FileProgress(file, $progress_container);
                    progress.setComplete(up, info, data);
                    $(progress.fileProgressWrapper).attr('data-pic_key', key);
                })
            },
            'FilesRemoved': function (up, files) {
                plupload.each(files, function (file) {
                    $("#" + file.id).attr("data-destroy", 1).html("");
                })
            },
            'Error': function (up, err, errTip) {
                if (err.code == -600) {
                    handErr("图片不得大于" + options.max_size + ",上传失败!");
                } else {
                    handErr("上传失败!")
                }
                up.refresh();
            },
            'Key': function (up, file) {
                return options.bucket + "/" + guid() + ".jpg";
            }
        }
    });
};
