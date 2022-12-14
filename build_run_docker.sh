#!/bin/bash
#Author: Bravin Shumwe
#Licence: MIT

# Run this script in a folder containing the Dockerfile

echo "### Build and run docker images###"
echo "Run the program in a folder containing the Dockerfile"

get_docker_image_tag_name () {
    read -p "Image (--tag) name: " tag_name
}

display_images () {
    while true
        do
            read -p "List images? (y/n)" list_images
            case $list_images in
                [yY][eE][sS]|[yY])
                    echo "Listing images ..."
                    sudo docker images
                    break
                    ;;
                [nN[oO]|[nN]])
                    echo "Ignoring..."
                    break
                    ;;
                *)
                    echo "Invalid response ..."
                    break
                    ;;
            esac
        done
}

run_image () {
    while true 
        do
            read -p "Run the image? (y/n)" run_image
            case $run_image in
                [yY][eE][sS]|[yY])
                    echo "Publishing container to host ..."
                    read -p "Host port (e.g 80): " host_port
                    read -p "Exposed container port: (e.g 8080)" container_port
                    sudo docker run -p "$host_port":"$container_port" $1
                    break
                    ;;
                [nN[oO]|[nN]])
                    echo "Ignoring..."
                    break
                    ;;
                *)
                    echo "Invalid response ..."
                    break
                    ;;
            esac
        done
}

select option in "Docker Daemon" "Build Image" "Run Image" "Quit"; do
    case $option in
        "Docker Daemon")
            while true
                do
                    select activate_opt in "Enable Docker" "Start Docker" "Restart Docker" "Stop Docker" "Quit"; do
                        case $activate_opt in
                            "Enable Docker")
                                echo "Enabling docker... "
                                sudo systemctl enable docker
                                break;;
                            "Start Docker")
                                echo "Starting docker..."
                                sudo systemctl start docker
                                sudo systemctl status docker --no-pager
                                break;;
                            "Restart Docker")
                                echo "Restarting docker..."
                                sudo systemctl restart docker
                                break;;
                            "Stop Docker")
                                sudo systemctl stop docker
                                sudo systemctl status docker --no-pager
                                break;;
                            "Quit")
                                echo "Exiting..."
                                exit
                                break;;
                            *)
                                echo "Invalid option! Please try again."
                                ;;
                        esac
                    done
                done
            break
            ;;
        "Build Image")
            get_docker_image_tag_name
            echo "Building an image with tag "$tag_name" ...."
            docker build --tag="$tag_name" .
            display_images
            run_image "$tag_name"
            break
            ;;
        "Run Image")
            display_images
            get_docker_image_tag_name
            run_image "$tag_name"
            break
            ;;
        "Quit")
            echo "Exiting the program..."
            break
            ;;
        *)
            echo "$REPLY is not a valid option. Try again!!"
            ;;
    esac
done

