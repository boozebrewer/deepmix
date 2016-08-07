function run_aws(weight, imsize, iters, init, org_clr)
if nargin == 0
    weight = 500;
    imsize = 513;
    iters = 100;
    init = 'random';
    org_clr = 0;
end
HOSTNAME = 'ec2-54-174-36-130.compute-1.amazonaws.com';
USERNAME = 'ubuntu';
PASSWORD = '';
PRIVATE_KEY_FILE = 'C:\Users\Ben Golan\Documents\repos\deepmix\matlab\aws\benkey.pem';
p = pwd;
cd('C:\Users\Ben Golan\Documents\repos\deepmix\matlab\ssh2_v2_m1_r6');
ssh2_conn = ssh2_config_publickey(HOSTNAME,USERNAME,PRIVATE_KEY_FILE,'');
cd(p);
disp('send start algo');
disp(datetime);
cmd_th = ['time th neural_style.lua ' ...
    '-init %s ' ...
    ' -backend nn ' ...
    '-save_iter 25 -num_iterations %d -print_iter 25 ' ...
    '-output_image spectrum_out/algo_output.png ' ...
    '-content_image spectrum/content.png ' ...
    '-style_image spectrum/style.png ' ...
    '-style_weight %d ' ...
    '-image_size %d ' ...
    '-original_colors %d ' ...
    '-seed 123 '];
cmd_th = sprintf(cmd_th,init,iters,weight,imsize, org_clr); 
cmd = 'echo $PATH;export PATH=/home/ubuntu/torch/install/bin:/home/ubuntu/anaconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cuda/bin:/path/to/dir1;echo $PATH; ';
cmd = [cmd, cmd_th];
[ssh2_struct, command_result] = ssh2_command(ssh2_conn, ['cd ~/repos/neural-style/; ', cmd]);
disp(command_result);
fprintf('%s ',datetime);disp('command ended');
ssh2_conn = ssh2_close(ssh2_conn);

