function get_aws_image(out_folder,HOSTNAME)
if nargin==1
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
end
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = fullfile(get_root_dir, '\aws\benkey.pem');

remote_path = 'repos/neural-style/spectrum_out';
%%
p = pwd;
cd(fullfile(get_root_dir, 'ssh2_v2_m1_r6'));
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
fprintf('%s ',datestr(datetime));disp('send get png');
ssh2_conn = scp_get(ssh2_conn, 'repos/neural-style/spectrum_out/algo_output.png',out_folder);
fprintf('%s ',datestr(datetime));disp('command ended');
ssh2_conn = ssh2_close(ssh2_conn);



