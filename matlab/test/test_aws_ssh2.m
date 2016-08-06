
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = 'C:\Users\Ben Golan\Documents\repos\deepmix\matlab\aws\benkey.pem';
%% simple
% cmd='ls -la';
% out = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,cmd);
% disp(out)
%% advanced
% ssh2_conn = ssh2_config(HOSTNAME,USERNAME,PASSWORD);
p = pwd;
cd('C:\Users\Ben Golan\Documents\repos\deepmix\matlab\ssh2_v2_m1_r6');
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
disp('send command');
disp(datetime);
[ssh2_struct, command_result] = ssh2_command(ssh2_conn, 'pwd; ls -la');
disp('command ended');
disp(datetime);
% command_response = ssh2_command_response(ssh2_conn);
disp(command_result)

% ssh2_conn = scp_get(ssh2_conn, {'test/test2.txt'});
ssh2_conn = scp_put(ssh2_conn, {'test/t.py'});
ssh2_conn = ssh2_close(ssh2_conn);
