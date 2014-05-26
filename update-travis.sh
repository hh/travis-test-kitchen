export KITCHEN_YAML='.kitchen.cloud.yml'
export DIGITAL_OCEAN_SSH_KEY_PATH='~/.ssh/id_do.pem'
# one to work on
export KITCHEN_INSTANCE='default-centos-64'

. secrets.env
# cat secrets.env
#export DIGITAL_OCEAN_API_KEY=foo
#export DIGITAL_OCEAN_CLIENT_ID=bar
#export DIGITAL_OCEAN_SSH_KEY_IDS='baz, pop'


ruby -r base64 -e 'Base64.encode64(open("#{ENV["HOME"]}/.ssh/id_do.pem").read).lines.each_with_index{|l,i| cmd = "travis encrypt DO_KEY_CHUNK_#{i}='#{l.chomp}' --add "; puts cmd ; system cmd}'
travis encrypt DIGITAL_OCEAN_API_KEY=${DIGITAL_OCEAN_API_KEY} --add
travis encrypt DIGITAL_OCEAN_CLIENT_ID=${DIGITAL_OCEAN_CLIENT_ID} --add
travis encrypt DIGITAL_OCEAN_SSH_KEY_IDS=${DIGITAL_OCEAN_SSH_KEY_IDS} --add
