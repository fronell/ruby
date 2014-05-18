require 'net/ftp'

def open_ftp(host, port, user, pass, passive = true)
  ftp = Net::FTP.new
  ftp.passive = passive
  ftp.connect(host, port)
  ftp.login(user, pass)
  return ftp
end

def download_files(ftp, file_matches, local_dir, post_download)
  file_matches.each do |f|
    local_file = "#{ local_dir }/#{ f }"
    info_msg("Downloading file to #{ local_file }")
    ftp.gettextfile(f, local_file)
    case post_download
    when 'sign'
      signed_file = "#{ f }.signed.#{ signed_time_stamp }"
      info_msg("Renaming file to #{ signed_file }")
      ftp.rename(f, signed_file)
    when 'delete'
      info_msg("Deleting file #{ f }")
      ftp.delete(f)
    end
  end
end

def get_file_list(ftp, remote_dir)
  dir_list = ftp.list(remote_dir)
  #if condition is necessary because nlst hangs if no files are in dir
  if dir_list.empty?
    return dir_list
  else
    ftp.chdir(remote_dir)
    return ftp.nlst
  end
end

ftp = open_ftp(host, port, user, pass)
file_list = get_file_list(ftp, remote_dir)
download_files(ftp, matches, local_dir, post_download)
ftp.close
