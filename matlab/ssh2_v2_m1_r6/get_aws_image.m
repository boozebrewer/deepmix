function get_aws_image(out_folder)
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = 'C:\Users\Ben Golan\Documents\repos\deepmix\matlab\aws\benkey.pem';

remote_path = 'repos/neural-style/spectrum_out';
%%
p = pwd;
cd('C:\Users\Ben Golan\Documents\repos\deepmix\matlab\ssh2_v2_m1_r6');
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
disp('send get png');
disp(datetime);
ssh2_conn = scp_get(ssh2_conn, 'repos/neural-style/spectrum_out/algo_output.png',out_folder);
disp('command ended');
disp(datetime);
ssh2_conn = ssh2_close(ssh2_conn);
disp('closed ssh');


