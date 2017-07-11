style_path="/data1/images/cocone/$1"
content_path="/data1/images/cocone/$2"

for entry in $content_path/*.*
do
    echo $entry
    filename=$(cut -d'/' -f6 <<< $entry)
    content_filename=${filename%.*g}
    echo $filename
    echo $content_filename

    for style in $style_path/*.*g
    do
        style_filename=$(cut -d'/' -f6 <<< $style)
        style_filename=${style_filename%.*g}
        if [ ! -d "./results/$2/$content_filename/$1/$style_filename" ]
        then
            mkdir -p "results/$2/$content_filename/$1/$style_filename"
        fi

        command="CUDA_VISIBLE_DEVICES=$3 python neural_style.py --content $entry --styles $style --iterations 2500 --content-weight 10.0 --style-weight 500.0 --tv-weight 100.0 --output results/$2/$content_filename/$1/$style_filename/final.jpg --checkpoint-output results/$2/$content_filename/$1/$style_filename/output%s.jpg --checkpoint-iteration 100 --network /tmp/pretrained/zoo/matconv/vgg/imagenet-vgg-verydeep-19.mat"
        echo $command
        eval $command
    done
done


