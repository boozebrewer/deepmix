function send_to_aws(style_path, content_path,HOSTNAME)
if nargin==2
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
end
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = fullfile(get_root_dir, '\aws\benkey.pem');
remote_path = 'repos/neural-style/spectrum';
p = pwd;
cd(fullfile(get_root_dir, 'ssh2_v2_m1_r6'));
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
fprintf('%s ',datestr(datetime));disp('send put png');
ssh2_conn = scp_put(ssh2_conn, {style_path, content_path},remote_path,'',{'style.png','content.png'});
ssh2_conn = ssh2_close(ssh2_conn);
fprintf('%s ',datestr(datetime));disp('command ended');
ssh2_conn = ssh2_close(ssh2_conn);

