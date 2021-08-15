#!/bin/bash -e
#SIKessEm
#package Manager for VIM >= 8

put_error(){
	echo $1
	exit 1
}

case $1 in
	'add' | 'a')
		action='make'
		pack='opt'
		;;
	'use' | 'u')
		action='make'
		pack='start'
		;;
	'added' | 'A')
		action='list'
		pack='opt'
		;;
	'used' | 'U')
		action='list'
		pack='start'
		;;
	*)
		put_error "Unknown command $1"
		;;
esac

set_pack_url() {
	pack_url="https://github.com/${author}/${vendor}.git"
}

set_pack_dir() {
	 pack_dir="~/.vim/pack/vendor/${pack}/${plugin}"
}

get_name(){
	read -p "$1 name : " name
}

get_author_name(){
	while [[ -z $author ]]; do
		get_name 'Author'
		author=$name
	done
}

get_vendor_name(){
	while [[ -z $vendor ]]; do
		get_name 'Vendor'
		vendor=$name
	done
}

get_plugin_name(){
	while [[ -z $plugin ]]; do
		get_name 'Plugin'
		plugin=$name
	done
}

put_error_argument(){
	put_error "Unexpected argument $1"
}

make_pack() {
	author=$1
	vendor=$2
	plugin=$3

	if [[ -n $4 ]]; then
		put_error_argument $4
	fi

	get_author_name
	get_vendor_name

	if [[ -z $plugin ]]; then
		plugin=$vendor
	fi

	set_pack_url
	set_pack_dir

	git clone --depth 1 $pack_url $pack_dir
}

list_pack() {
	plugin=$1

	if [[ -n $2 ]]; then
		put_error_argument $2
	fi

	get_plugin_name
	set_pack_dir

	ls $pack_dir
}
	
if [ $action = 'make' ]; then
	make_pack $2 $3 $4 $5
elif [ $action = 'list' ]; then
	list_pack $2 $3
fi

