#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.14.3
docker tag hyperledger/composer-playground:0.14.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �;�Y �=�r�r�Mr�����*��>a��ZZ���pH����^EK�ěd���C�q8��B�R�T>�T����<�;�y�^ŋdI�w�~�HL��t7�Y�j�>���B��{u;F��k�O�L�#�0��BP�OĠ	��!Y�b8(�O��@��c����mf��[��W
dZ6v�s�9�Y��h*�v9 O'�]�~3l���`��>e����F��LU�����CmcӶ\� ���aGإ��2dt4-d���Q����,|��R��.��{ ���^�f��w�������aڐ���`X^�$��|,��-Gz�����J����
�0��ӆ�j"�V����dbQ5R	�6�Eah��!��0����E}?�I6m�膁T�tڱ�k��w��u[C�������_E�jjm�~�a �*���Q�I�[G\��D��ml2�@��P���B����QԠn-䫵v�0a6��$*�t���萖c�T���Vw��]�V[G��!$�v
��J����V����Ej��v&A��u1[<^��.6[�㵿a�m�~�1�;�~y���sF��]7�6�6z��5�GYv�p86̔�0����}Hu�2ߖb�u�ne��v�������b�3���f��+UT������F���\29w}�p��=>p=���:>:�=<8�E"�y��a�&�� �b8��\���3��F$��]Ý_�V�<���揿(It��`H�%�Ĉ,E���*����f*�jpvL~s�U�����c���1����xT.ēo��}l���A�[%�tI�A��+���F�a����p~V��k�_�����߆j֑���ƃ�`����?Q�,�#^B��������Wt�9\��T����������[3Ho#Y�lh��`Ζ�a���:H�m�)F�N�mǤ+3�o��:Ц�٦�X���s��fo�0��k�����Ȃ�<i8���ܣ�1�-?��y�R:v��{Nq��+���Ȱo�XM�$o/�n&�iu�������Xm�8ܵ�-�;�C-*�o��N�Fͭ8�^�ASmh�5���|>������Z@�x�(��	�FY\��I1)�?�Q�`ۀ���W��H��Ý6�_�It�ɠ��g�M}����@X��St=���7\�I�)���,F��'�D�뿕�x��=4�5�`���n@45]Ш�p�BL�04�>z)dq�J���[��5��{�[U�B�m��mN���4�<I���y��%i����GiC��&���A�(l���809e����$s8�]�˽@9`�f0��W�|��S����ޒY Z���a��(�ώGB{�?M��r��z�֨�c�Rd>��vm~�� ��2�.��̚թ���mޣ*8�� l�=�!c��K3�'1ǟPq����U���	���٬����Ǟ� ��p����#h!`!�6�64�0�l�π�܏��SN�#`��x���x}�Sf�6��@3�y���,�^!�7���&�neO3�f��
���`�ի��!��5�nV`�<t��^9���U���S��
3��H��C���?�Pd��[	���n�a���| K�=;��ȂD���E1���U�'%F�0nt�n:�=����L��v�&��1�c�� q$��f�Kd
{��M��~���/d�K{�ׄ�j���������1��s*��}W$�M)�B&��$Y(f�r/.���ًy'�fǰ�����Ӣ�SC��\���CE�-4�&�HW�7'a�B妼ŒR(}(e�ɣri��h�dC`�Bd�����&L��CnhXh���|+���_l�CyD��۷`s&�?�M����pE�b˹����!0�V�<��G��J�H��>Y����@�(Q�>�<����Ղ��Z�Es�������+9�D�}f�;��Y���u��u���4�\ .���(L��H(���U���?��SþgF�4�����m��v	9!<Л��^��0��������ψH���?W �ǟ-q����7����$����U�m��>�������������������$]�c�,�M��4���MͰ���4����Kp�����];�B?9&�B|��M���/������OD�����1�7�]�,���Y6jzȈH�yA��"#z���^�n�_m��^�u_8an�LE���Ա
uzH�F�3�|f�i����V	��"�3F{
ytc&��#v�H�U&^+����S7p�;�3t�O����@�4�!�on���s(|�����O$$�"����������A�|�^s�^���ذ��RȎ��xWA_�~�������@=���w����?�_�w�V�ѹK���x`GmT+U��m��>���H�z�'I!y��������,cK�7lP
��G?%&����Q���C����}^
-=�f�eѽ�!ɑ�����}��Q��swY���,������=��:�4�	{H�0k�X��$�_{UNm�p �0�[�
�,	�a0j�6����J|���G)��-{m�]���ҌgK����ڽdFY#�z��-�M2�%��x�;�StLԑ��`2���L^�6�R�̜1�}:YƬ��raL6u*�����Q6�_�Afy��y�R����AA�>G��;&3���@�@Zd*D�����^ɼ[�Ռ����|�on=�<�'����	�����<�#'�'�}�����PD��]�� ��r���}����������+��柟���A�e)�SSEU���V���N4�U��,E �E$��h%�U(GCѨX�설�N(���r���&��l�+��J��k$~!������tz�x��&�űaa�֜��?m�#�1��F����7�f�ȿ��7#:<���庳6�e����n��H��O�OM�x5���xJ��fX0�S@����W0����;�?�Ȼpw�g�x���K�,$�t�$.`��W�8��t�����K7�_��������O J�Z��W�,��&�K���A�n��<���t��߽�-�N��2l�c��(�V	Wj��	
;��(��reG��R�Px�
5(*w"0Z#F�,�"��6�vͫ����hs|b�t&��B)��ĕR���3��L<}�+j��t31��)(9��8ɽ�U�t��h8����x�,s��3WB��vի�!��4ӊXN����I�2y�b��	!U�7s�JZoU��x��L](e��ZJ��gZ,��P[)�LүΤ��tIy�b�R2�_%��7�F�M�:/�.*�p��P���-%�\�qؚ���o��lI��.2R���J锖]�2aP��8��U�y�ϟ%N��t����|�,eI����cك�����yGm��g��i6�w[~�ͽ3�R��$�{g���&wQ�Jֲ1�a(��i��`�ӐB���C:J�l5}��r�J)vNz2�M�z�ŬU��t<�}�&�!������e,/����R�v"�7����E�'H?�J�c��a��$�ʵ3x��`��i�l�<r��&vr�H��V��s9�K׻�R�0��d,���D7t�t���	%K�z���)���r�(ٸE[U�t��l�@��Z�9t"�L,��0���A�c�E, ��L!�
g5�uh�h��U�ed�PW��r<����A>�Έ'�+�3$���h�4h�/"�L��r�$ډW�L�:�V�u��S8ن�L7�8�wƛ���1�^\�F:�\���3��'s�f���}���!6ꇚ�|$3���\?�_ݳ��X@Ű@���G�g����^�����>q�������>���kX��/Y���?��/H�:�[��Iǅ�	��A�>岙�>���Est,-t!����� d������Z�~ʝ)'BQ|�r�S]��R�
yCr$�+J��ĭ|9Whg�ͫ�G^\�ȭ��_TP�)'�4˽|!��t*��Ki�o�e��ґ�$�*�D��&�Kj�X�����p�ٰ���_|�|s����U�g�����n��|�4c�������r�0��S�n�{��mĕ�p+$���D��$a�k&S�2,�^g/O�N���z��O9|�:Oe�I�:��7�I�m`����xppؼ��e(�]��Һ�Bt�m�K�P�{{���d���~;�	��kۘ,�iu��W��;�=����u����3����EfbY��l����@�,P@L/�~�=ey�x�;t���ܽܚ��]0�K����P��HGf��$PM34vb
��.hhWlC�-h�:M�Z��/)Ҙ<��e�8��1x�>�c?�3� @��f삱�U���yS�|��T6�E� }�@{T����u5:�K0�H�0QF?F��-��� Ow^����ӓm���IK��*/#?���く���F�l�C����`����d�+�{u]���M�jL���Dz���cz�܉�1�^��@��]z���L��"�m�ҵF��G�5�^ ���	{�!-$r٦�,B;I�QY��4*A����B�z��l�� �*���F�۠�`�O��FQ�������{����'}�W7���ˀ�6��NPn5�kMh;�ALbS�"�z�'�֍�H�b�����tGG�$�;�c��������7W��}~!/7m�^k �I�v���L�b��6I�KRs(�x�&��T�:H��M�Ǽ����0&eZ��xR2�̯۔�'�R�b�Ʊ	�`p�!+�V�|"�҈�
��)R�sʯϹ,���	�pwt/zҁ��4Z�D�+a�f �:8"l�c�����2ŃC�ߴ�&��5�{P�ߪ�[K��'�����;���z#��R��⨄l&[���K�j7�W�2_Ut	�����G�k���:��+uM�騶K����`���&��Ĳ���];t�!��T�����TTݱ�_1h�`*�nx�<��f���a�n�:������
�8�M<:!Z��Uʷ��1�U�����4�4��;l�n�>׺i��а`d2Ļ�d>�>���������/>�9�-�[���{}���]K��XZ��i����4��.�n3ݨ�{���$�\i��I���t�,JN�$�8���8�]iZi@�A�@�CblaX ��ĂB�5�?�<�q�n�^�9��[e���_��;�/�Q(Эa���𙭍eE�vbl�Gp�t�&���߮:�5��1������8�6�4A�{Iȣ��H�K�G��_���_|{�W���q�gJ����/��߿��o>�������8�}Y �v��{�?|��G+�6�u]Lh�g�%�H,��2&�%JGU��"d��D�JS4���8E���R1'�#�����V�a�_�տ�r�͋��q��_���:��_P?|�?���`����oa�� y{��5B�A�{�؆�����w�������|�|M,B�� ���?=@~�ŷ���-�C��b@�ZLxh�"�i�{�X���3�J���S�۽����b�c��%@W!��Wy�*$��j�l�)���QU|[dGk.J��"�32j���%C�獹x^���l?[8ϊ�3DL��Ē�8����UI,��M�1ר���A|��=�԰�|��-\��@vK�L�5ȍ�Dn&��V҂N�9k��=��d��[�Te� �X��T��~�;o���opP��N7X.�����4�`J���fQ�oR�%]4��)�4s=�uCWM&��k��q�����dnV�/���*Uh;#Փs1�Y�f	+0�4�2��wS��A�Xƞ�i�6	�`,΂�%'s�b �lɌ!�H�B��Mɦ~5�n�0���\�����ވ�gE�>Zd�~�7� 71�\ɮ����br��s�m�|W4�y<�S�c-[�'��1�0�6�X�f�݄����
E˳Z�b���0���-Z�����T��;b�j������<��k��.�K��K��K��K䮸K䮰K䮨K䮠K䮘K䮐K䮈Kd��
�`�E�,�"��Iљ��Q�P;Ǿ��gu	/���%N�rML/%��m�C������XSR�%t�]T��ƭUt��TO�J� @���&�J�N� ����:�=b�T43��Y"{��sS�6kR�}��gIa�����R��F�@0�&�d�"�͒�+�B}���5�;T��^� ��y�m���q������+|n���	C'�y�9_Zx;���/�K�O�I��xG�|2N�������7�
g%��Z7�-�����T?!0�l��qz.�'T>�?�jt�Y�O�D�:���w:��,F�+�̿���������C��Bo���q��÷��-���`�^7/���Y	���w���-���ۛ��H�ڋЧ�w��:����C�͇��kP���^<�yܡБݗ7Co�^�;pY��|z���a�_��>r�~������ ���{���ZQ�]ڢL�W:_0c��dhl��-r|�T��N{K��ҋ��I�){:?Al�}�J:���-
�<�\�m�f�V���Bnc5%∮��w]�e���.�O��Z(0Qj#�ݶ�,v�8D�� ���r��.�d::�t���y���6;U�<�`B��>�X�����4��Զ1NY�I2F�S[��LWƙ��YH]b򎔉Aղ��$�n/��v<���B�`%�4*& -(\���	Vn�ˁ�2hWc*��q�z��rjtaK���k$ˣ^��%s��)�n.�p,�h�VW�B=�¥^e0�☤֣d���-�.F�Т1�W�6b!]���ǘQ�:8�c�j�����l��	�m�^F'!��_e<��k�&�o(T*��8�f�X6ot���rK��_��������즁�\2U�@������X��I|D���9��q�EN����?���|�cw���;m�s��v϶���VM�S7S�Hp��D��ih�d��ue��-��!Ms�&W�j.��kZ�2Vk�d�#��UͦU4㸽��(
f��}��c�r�"�yc�
W��C�w��0֩�,�l�h	#�[�Ej�-H��L�g]�3=��z���Nlw��\�n"��Tuٮ�Tz�(OO��XAM5�j&]�Ke�g��Ya#��M�O�K%�f�.'��T:��'Қ�G�N{��L�����c��(R�XfY|�\6�_^�9	(��J���٠8ֵ�T��lV��q�*�Z�~��J1�"�'=�QGn{#�,�L���x�Y��W*�ގyʤ�yO� �=��
��F��j�41>6h�\��u��||§���OL�F�f�bY���X���ˍJ�f��z�2��R}��4$��M�F��BA<��C�D+نt9f�å%�x�Z�nf�����J����ˤ��6$��PX����1��ؚOqJ�֘�����y��R'(���&�UP����6�-Kd�Y\bM�H}!5��Z����<3�vide��r�[��0`��z'h����n�y���d�q!���k��TÜh�W�Б���/"?Nsա15��X�zy��#?�#�X�l���R�z�y�ٳg�GϞ��<�Bށy$�QR��Л��ʳ�g��Y��*�������z���+�?O� �e��e��Ȯ�7 �=�L�������dSv��'��N������~vy�]FQ&�a�F�
=D>r�O�O�Уץ{��2+G�k��t�t�� Od�o�������@F����}����m��N��p�u=���8�i��
�N�!�</wa�԰
��+ឝ|��.:L�U�Fx,O�jBw�#/�8���
 x#4�����8��}?}��M9�ٽ��a��z �w�s��}�9�
c-C>�.]/�������̺^d�c�v�״��9�*s��';���\@혚��[O����"�	:Y�O�R	� �\ �O�A����]�( �� ��f��D���67 D� FW��AE��7���B;�~�M�m�1<5 �b�`��I8,�a�7��Jx��:
 ���4���ԙ����d �|�B�Al��na@�9��8����8��O�����p��d-��C�>����:Z�I�zW�x��L����w��~t.P���"5�Z�, ~��ί�������&��&'��X6{��\�چ�����9U���.�#��+b@�&:0���,@'v Lm�q�]Or+! l��D������K#�F�Y��������	�˭~f@�����9�ۛO=����3۽�\;ؐ�_����aS��_��l��UM��dd��s��EC��ӡ+�m��.6���҂��uy&���.�-o�Àb�%4`un��� �O�(�-`��)� ��$�?��'$!�[]�V׸8sx�n�e��ö}<4d��h+[�0(i�+YU��֕�u?�Ʊ�|A�~WQ����p��qzHtp��ݾ�(cC=�5ݹ�a�t������#��}ԗ;}ف��M8-�,N���{�	�×m����S��{���W �':�c�OK�@����Cm*�[�,�'xr&����A
��`�wc|=��D�� g@���ֱ�Q�yXt�1�y���]�Վ���
��z��<wk�@�X�5�e������Yvaړ�̕�|���<܏,o�@֫M��a)�.�:�d%��&�݆㱰�{W���زѽ����/�x�m�o�z���tĸ�j�F�}�E�D�	�f�@}k��u�)����	�p"|���)���@��d�����a�p�y	j 3���+{#PQ./�' 
'0��pd��&^[b'�O0�?�$�ŉ��^�sM#��#p�����T�������-�`�p�����i�&}Wn�[�/\8n���ۏ*��s?� �C�kGx_��|_�?�}�����6���OE��*�������H`�!C|J|� ���c�숹��JL���@���gu�:ɰ%!q�`�@d���j�ѝչ4��`�/U��-��U��,��U��ǳ���A�]�z�����'c���N���#�"w"�"d�EE�*S5Buh��n�\�vpY&Z��8��:�N��I2��-�}G�����DXq¬�gn,�*��ßn�ǱxÏ�'O�Pa̐�bǂ����W�W%�[4%�Z-��aQEVpB%ۘ�e��ɸ�btL��-���#�L��*Uq��U{b[N���sl�+��٘�v�@L�����m=��h�%pÓ�9��vQ��q׾`g����]1/e�|��K6U��_b�g�|*�W��SEmM��g��c8�ė�O1h]a�������K�<��_�u7{y'��\X�bP	&+��4p<v]n�j�c�u�sP�����L�3�hl��8WC�I�jfoڂ���V�L�9����`���w�C��d�M�Z��<���D�;�L�v��3d����d7�_q�r9�oE������<%�Rg�/m:|�H3B.��V9��x��Z�Z��W�9��t��OP��љ<A'ӡk[=1��	K���l����(���Kf-m���'N���|YJ�sI!u��Z�t*ڣ{��Y���z�k��Hng��:�)��3��>����Rvٲ�H��c$�e���yʱW�O�+�4Ǻcr��&ȋ�J�c�eP�o��G������;�O;�n���0��H �:vS�Dt�NSw��h>x6��&�ݜ��ηl�1�-V�+X���աb��>�<j�߹$��G�����jq�+$���"��c�*����f�<P��������w��v�80`�w��/4�S �F�N��#�q��ytG7]���O�|��酯������Gp�sX��O���o
������#�?���іo6����������t� ���^�O�ئ����A��#�K�ß�x���M���W|��)����?��K:x�9x�9x�y�h^6K?Wz%�?jG�������/�OUⲽ�X�Dc
n�ǔV'B�UEnǣ1���1,։�#T4Ҋ�1��)*Nr�̸/��j�Wa���m���k/)`�m��|��V縮Mm8�+�4}�W����&.t�i>Rhja^���SM�"zAwJ|�D;|�1����JdM���J��i-V���FG.�fD^6��~�tR�4�'�ji��Ӊj������1�s��������?�
��p��������yH��>��6��x�p����*��q�9��}�}��K��/{�_�t�����������][s�h׽�W|�V��o��IEE�7_"�	�׿�t�{Zg�Nw���^W��IZ���k����5��mR���S���v��^�;��%@���Vqo�@�U������a�����h��S��aJ�:T���4�I����4��� �	Gu�Q���Ο��x0�	�� ��P����?��C�����������~h@��g���O����
�V�[��?�����t������a�:�/�B���,k��)}��tn�����~ޞÌ�������'���Ϣh?�̪`��}{�/k���"	v*)�j�7�R�^�ͬ�[4{�\��C��Y���\h����ut[��5v� [���y��]q��C��� ��_��|Y��~d���;.W�yP����w��2�"�ٓ�M�Ko�]�َ�۽O��_6��� M}56�Y��L�Hz.�o�-�P��z��Z{�]��Oc�=���OY�:��a�׵,rT̚�(����i�����m@@�=-��P�����	���m@��!%�j Q�?�"���J �O���O��To��@����� �/Ob��P�n���?6����@������������;��?�Z�;g�9Ӄ8gI]��ɀuS�7����_���뿔��7]���z���`�q3��N��h<�k#�k7�h6F�L�w��e5/��7
��IZ\r)(�v��s�?��A��v{;dM�P��k]��X<����N�l�b�?��KI�
-����^��om���_8�����	�)IL��9-�+��FJm���1���IIf���m���)�8^�&-I#�z�dO5���3M�/#�#c�1��`��$��@���� �o]�C�����P�n���S�}���_	P���< �p��g��3�38#A�Gt�\�aH���r!I!N�l�P�g�8P��G��P�W�_����=O_�)4[M���4�O�R8gQhP���l�]��/������.N��8�OPu�"gGB���t�����y`��m��l)9���籚(����K�΂�3q�p�Ϛ?�@��[����?�C���������?��	����ڀ �?��?�e`�o�'
��_}����ѴT稫��vs����3�uW��n���;���K���(����x�L8߼�lW��nۧ���v��٣�U��2O����e]H������M�y8[���t�	<꿷��?	�oM@��������7 ��/������_���_�������X��w��(
�_xM�y�U������ALڲ�G�̈́�BM���.���%��g/����0Ǯjk�3g `OO�� طz�� W��G�p)>T����W� ��<���.6�CJ�e�%W���ϱA�Ք�n��Zۥm+ö\�d#6���ODu�����^>�wUo�~)���f{a�Ş�@ߍ�//����z�� �ے
C��{)V[�U|b���I_�4�x���HR�(�n$�,�xޜ�)������?o X�rk+���V<�Ԥ�I���?i Ւ5u����������-C�1��)I�sE�m����v#:˗���H�HhFv�w.2Ŋ��&5:���3�|�%�h�/+����"ڋ(�?�~��h�U�����袊��Z����x��a����������W�J�2��EU�������?���x@�?��C�?��כ�D��M�D����N�87�g�!���,-Dγ|D���v�O��"����#X��0�P�?��š�S	~������R�\f�Yx�1I@�F�|V̂^��]��A�}����J0�bup��^�Vk{�q��O�b�m7��ϒM���qR]X���2bqѥג����c�.)��{Y������Ԧ�o
��~p��?������P���������Y���
 ��������g�2�Q�?���O�w���U���_�=�/��AU������_x5�������汿��ˬ)�/�KRu����ò��oE�_�U�\`?3�}{����[+����[���3��N��a��~���~�,��:ێ1J{'Μ$S}�d����C�+u���xĭ��|����gv�0�q^V(�isZn�C֣�K;.���H=C��ح��<g�߮m'V�0�-m���$M����*��.��Q�����[���]�C���~*;Օ5K�s�b1Y�w�3�h�/f,4[��)�۱[���<k�Zl3:�n��e��R5�U�0�hc����xr�i�;�Lw("=�]P�W���քj���*������'	
�_kB���������7�� �a��a�����>N��9X H��ϭ�P���ׇ����!� � ���A�/�@�_ ��!�����?���A�U������/��u�������������$�����������m�n �����p�w]���!�f �����ă���� ��p���_;�3����J��C8Dը��4�����J ��� ���������a��" ��`3�F@�������� �W���Bj 
�����*�?@��?@���A�դ� �F@�������ڀ�C8D�@����@C�C%����������� �� ���$���� ����H���g���W����+
�?����������W��?$��@���� �o]�C�����P�n���S�}������Uxı�9���9/D��P�I*���g>R4���B@p�/�4�p���'��
�O���5��0�F�
��tu�R��;׊S��
Tj��,+�q���$=M�B�
X��#�&&���קuK��r�[[���,���I�-�f��*[��5����i#�b��܋5d.Lk1�C��X^��n��>�~(6�x�)�6�d,RC�Z�ݽ���pĀ���?�C���������?��	����ڀ �?��?�e`�o�'
��_}���� ���8������vh���Yf�}�?[��|�������N�:�G{m�M��p��~�͒�Q���������L�[ڮ�N�R����4;���`g(�>Efͨ�)];*��r�P꿷��������V����G����P������ �_���_����z�Ѐu 	�w��?��A�}<^��������O�#J�{vkO�|y��*s�����{�v7i�H�䵉,X=ց�[2�����W�6�i%�X��L� �;�͔`7N�N>��~"ڽx��Ü��0֗�R,˃��S�i^�^�ftI��o�F;-�{m7���ӷ���K'���-�%�t�,�XmI�����e�>鋝f"�}IJ��aߍ�rk<���>e�s�v��~Y Ւ�wܝ��I�I@%�L;���ۜ{gon�B��[y��H�p2�����S��ū��1D2��΄iD��jη�������?���~���|�7���ei�ao� �Q8���G\���~�����OP���(�� ���+�G���`�YTq���i���%@��I�������U�����L�P��c����w���*��g:�,�._�?󴱲�$�!H��§��\(�:�����K��L~�,M����\�K�t�����]<Y~�{��x������U��oq�޺�)~�.�7���\�RK�ocKƎ�Hq��iդ���!I�m���n)����5rvmTl����F�j_e����1ɟ<��bR-NF�kQ��f��=�d׮��mj]��S���b�|1q��s�����7���]_/k!�S��XT����=��s}��4��31Sb+�d�s{SgG5$k�-?"������ٱ��2"ϡ��V>mt��\��숊���D.z��KDLw+8	f6��#N&�y �6�&��H�F��R�6}���S��o����*qOm*���x^8쾲���$�s7��ߊP���X��n�4�s*$���4
s�&�7��<�hJ���!�Q ~���6�?
(�����W����W��+l<;���`������Q0���c�=���3r�Iї��{��Z��#Wnj��ߊ������w����
��������U�
����!�*����{?�ǂ���������_�?����N�Hi|1Un8ag�����j���h}�S����l����՟�~��x7�{��71$�����~/��6�Ϣ��ݱ��hu�#+�݆�����v@�O�L�f�k���H6��K�EȊ�&��<k��G�9?��M�'Z��l?콾ߋ�=���@-7�$6�Dt��<jp��o�;Q��eڲ��XԦ�RԱǾ��L��j0i��p7��;ф�W���D�q&hZ�f�!�_����[ʜh.�m���Q�;m{cm٥��f�����q������ �G>�����JP����ِ#��	���$y������E�<��y�ǯ�%�j�O0�O���(0�>U\���(���J�+��V��dm"2Z��9�,��h�7��0��J�U�:�r�I��/[n�{�l������-���G��U��U���?�_�����v�G$��_7�C�W}����c ��������w�?GB�_	^��ȷ������i��i��2������y|\���_������������V)���sV������Ljjn9��C��o "x���֭ /���v��~�xLN��yt¦��T%1�[���^k��e���Zu.E��D<5��r�6=��֖u�����j��KF��2s�}���e�
{^�r�M_N�%�K}��v�/+ᅽ��pT���<��q��lm�y�S)l�Ѭ�����>��˱���X_�(��=��,�gU�f�MW�p^���L��t��-1�Q���Z\r^�Q<��(�8.i��}��Md����}���n���zc��WֶȎ�M��ac$?��#[���U��~z�^Wv���m�Jǔf#Si����<�>�S0�l��Z��Zbc��8��k�"5$k)4\Yd9��I,���Tp'B��+��g.��Ƀ�G�Z��2!�������+��߷������Б��C h�ȅ��ɖ!�; ��?!��?a����?��@.�����<�?���#c��Bp9#��U��T�a�?�����oP�꿃��#����_���=�������p���!��^�������_��C��@�A������_��T�D}� �?�?z�'���X�)#P�?ԅ@�?�?r��n��B��gAN��B "+�������?@���p�����o��B�G&��� )=��߷���/_�����ȃ�CF:r��_�H��?d���P��?��?�Y�P=��߷�����d�D��."r��_�H���3�?@��� ����ߨ� �?�����\����}����F���ʄ|�?���"�?��#��!����\�8�?�@i�-�C��	�?:���o�/�_&��X�!#r��C���vNkF�"Yf�[UҤK�[�
m�l�$�1,K�j��2�*Ζ���E?����Ƀ���k��������ɣ�-*4������-r-�%��oQ���� ��N�/�v�vm�9�M��-�5�0�XXW�nM��j5���Ȏwx�%8=�4]=hyV[%Ƀ2�"�V�����m�-1U0�
��JLOS����[�nǮ�1Cx�4��/��]���l�K�(���P7x��C��?с���W0��������<�?��������1uQ����������5�EJ�z�C�K��YL���նWӶ�n��bkO���)�����,׺�=|S_���`M�-�
G4ڭʕ�n�e�F�(m��p�h|�^bi9�,����ɥڥ'!ҎŞ �ߗ����㿈@��ڣ����"�_�������/����/����؀Ʌ�G3W�E�������l��?�mՎ�zپֳ�#W�>k�t�_}�����X���L"}�b�O۰ףm.s|�4����,>l�F�k�h�ֽI����~\�Xɸ�a#ܚcǢTS��'�N�z䦵��AY�j�Z%j��-6z�ߴ8�l����O?e�k��ٖ����d��-���Q{NSH�<�6N�{�{��$9I��;�%*5ε���{m�a�l>9���+rw<��&��+��Ϊ�ݮ���_�kS.y������&�+�b%!�^�u��ʐ*�G�.m���	�ڍ���ԟ��{M�?���O�������S���?7��߈��)��Ȃ\�?{#���ς�������'���������O�4� ��S��s@�A���?q#��2���Zu[�#���������񿙐'��*�ٓ��m��S���x��#�����K.�?���/������ ���}���X���X�	������_�?2���S���!�C�+�� r�?>�"ۛ0s˸�����I������Ϲ��
��r�Ϲ�/��L��)�����I�^rۗ�����ey�ݲ�]�H���X:f}�ŪL����P�k\֧����;3��'�uӈ)��3��*��8Y�ەetJ�ž5���������t�vy�d��В�¨Ȳ�&�N���ڴ���1'O�G������܉yXv&�N��z="��9a��-��R7Z/���5ӣ���*��n�"J��2����4�
U2�֪_
2�,�g� ���#���jp�mq�����_.�����'�~	� ����F�/��3�A�/��������� ���ap�Mq�����_.���A��#��� �hr��C�?2>���j���W����o6����T)�=hM�?�������I"ٗ�	ug�{+c=:\��( {�����.�ԫ�CHu��F:͊\ӌ���2��~K֦*�^�l�oF%L�w~���i�sZ�S"���Qf��F����?�����NI & ;%�Q@/�'����Tŀ�2��ŋ�cJ��`�;�ȢS��;O��U�+�<Uת�*��$\��irga��$"M�a��5!�j�;�O��3�����@��L@n��_uK�'��߷���/7�?�A�� ?�OU)��ʬe1��U+�9/�:iѸ�P:A�I╪I��k,nY�a�,cV+,9g�wя�f��������l�����w)��?Mg{�F~�F,F�~4��ڊ���ӸZ���y(�	Yj����&�K��^�V�����	첦���\a��,.�Î�{I<�Ǎ�,���rL� :��O`��/%�?��D������s�������\�?�� ���,������.Ƀ����������j�,�zGR���j�%�����է����i)�7�n.���f8ؐAԨ��֣V%!!��c�C_��<b�9(��wܖ��@1㶤���Rg�G�a��"k��(��/%��U��R��g����``��"���_���_���?`���y��h��">g��O��-|���#`�ޮc��"����]�t�������i�}[ vY�u@qiG[m%2�FӺE�e��b%��?���n,��9��Dj>U�e�l,f6>0L�u���C�HkOM#��ATfEu��W�_?6󰓝�k\���y����d���a�KNc���u�u>i	��`�LB ��/��fP�H^<ԕ�(zi��-�G���m��L9���Y�� �i����2\�cCz*7�o[|��O
�$�����0�@2v$=�[0
9�+{vP���'���==a�@�edT�'�������73�;N�Q�V�������I��[w5��_�gF�q*��>��b(�?�ݹmz��j�Yxx��y���<h�TQ��ƅ:��d�P��u�A㗷�q;��O�{B�rWfAx�s�gSAJ�&r����m̯|cYx|=����i�Qp4�3W�C	����˛����7�;�py-�
��/�����|��zJ������������0��K�d��I�8����J��t-r0�oq���+Xn�3�� t����V�'f�y���̸�`������4���c�^mC�zB��l=m����?�#K��b�,�04����0��XM�����?
Ƽp�'����7o�~�]�=�	�����ۛ��)��� ���ңb��5=�oo�?����ߞ�.�S9	�y[���޿��>���*�X�}��l����t�����凅�!0Õ9�Ͱp~�
�_x~���\�����ֹ�B��n=����*����o�ςE[�� �\o�n ���p�˿WZx�&o����0�p���_o���L3�ݭ�ٝ��#�H����s0�B`�!��6���~���8��/����x*П
�Kfl���W���D�t���z�wJi����Ǐ��!��vO|��޻V�#�պ,=wrW'qJ`�F'�<�]��7�vx�E�8���饿t�������x�}                           p�� ��� � 