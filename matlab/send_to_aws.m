function send_to_aws(style_path, content_path)
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = 'C:\Users\Ben Golan\Documents\repos\deepmix\matlab\aws\benkey.pem';
remote_path = 'repos/neural-style/spectrum';
p = pwd;
cd('C:\Users\Ben Golan\Documents\repos\deepmix\matlab\ssh2_v2_m1_r6');
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
disp('send put png');
disp(datetime);
ssh2_conn = scp_put(ssh2_conn, {style_path, content_path},remote_path,'',{'style.png','content.png'});
ssh2_conn = ssh2_close(ssh2_conn);
disp('command ended');
disp(datetime);
ssh2_conn = ssh2_close(ssh2_conn);
disp('closed ssh');

