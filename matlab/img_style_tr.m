%% paths
style_path = 'images/style.jpg'
content_path = 'images/content.jpg'
algo_out_path = 'images/algo_output.png';
algo_out_folder = 'images'
%% send to server and run transfer
send_to_aws(style_path, content_path);
%%
weight=200; imsize=300; iters=300; init='image'; orig_color=0;
run_aws(weight, imsize, iters, init, orig_color);
%%
get_aws_image(algo_out_folder);

%% show
show_three_img(algo_out_path, content_path, style_path)