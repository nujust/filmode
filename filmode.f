      subroutine abqmain
      include 'aba_param.inc'

      ! �ǂݍ��ݗp�ϐ�
      dimension array(513), jrray(nprecd,513),lrunit(2,1)
      equivalence (array(1),jrray(1,1))
      character fname*80

      ! ���[�U�[��`�ϐ�
      character outfile*80
      logical flg
      integer outkey,mode,outmode
      real value
      dimension value(6)

      read *, fname    ! ���̓t�@�C���w��
      read *, outfile  ! �o�̓t�@�C���w��
      read *, outkey   ! �L�[�w��
      read *, outmode   ! �ԍ��w��

      ! ������
      nru=1
      lrunit(1,1)=8
      lrunit(2,1)=2
      loutf=0
      call initpf(fname,nru,lrunit,loutf)
      junit=8
      call dbrnu(junit)

      flg=.false.

      ! �o�̓t�@�C���I�[�v��
      open(101, file = outfile, status = 'replace')

      do k1 = 1,2147483647

        ! ���R�[�h�̓ǂݍ���
        call dbfile(0,array,jrcd)
        if(jrcd /= 0) exit
        key=jrray(1,2)

        ! ���[�_��
        if(key == 1980) then
          mode = jrray(1,3)
          if(mode == outmode) then
            flg=.true.
          else
            flg=.false.
          end if

        else if(key==1)then
          id=jrray(1,3)

        ! �w��L�[�o��
        else if(key == outkey .and. flg) then
          if(101<=key .and. key<=104) then
            id=jrray(1,3)
            do j=1,6
              value(j)=array(3+j)
            end do
          else if(key==11 .or. key==13) then
            do j=1,6
              value(j)=array(2+j)
            end do
          end if

          write(101,1000) id, value(1), value(2), value(3), value(4), value(5), value(6)

        end if

        if(k1==2147483647) print *, 'Error: Loop counter overflowed'
      end do

      close(101)
      print *, 'Output to ' // outfile

      stop

      ! �o�̓t�H�[�}�b�g��`
 1000 format(i8, e16.8e2, e16.8e2, e16.8e2, e16.8e2, e16.8e2, e16.8e2)

      end
