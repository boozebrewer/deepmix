cd('C:\Users\Ben Golan\Documents\repos\deepmix\matlab\ssh2_v2_m1_r6')
HOSTNAME = '192.168.0.19';
USERNAME = 'pi';
PASSWORD = 'asdfasdf';
%% simple
% cmd='ls -la';
% out = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,cmd);
% disp(out)
%% advanced
ssh2_conn = ssh2_config(HOSTNAME,USERNAME,PASSWORD);
disp('send command');
disp(datetime);
[ssh2_struct, command_result] = ssh2_command(ssh2_conn, 'pwd; python t.py; cd test; ls -la');
disp('command ended');
disp(datetime);
command_response = ssh2_command_response(ssh2_conn);
disp(command_response)

ssh2_conn = scp_get(ssh2_conn, {'test/test2.txt','t.py'});
ssh2_conn = scp_put(ssh2_conn, {'test2.txt'},'','',{'mytest1.txt','mytest2.txt'});
ssh2_conn = ssh2_close(ssh2_conn);
