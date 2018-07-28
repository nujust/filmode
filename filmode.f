      subroutine abqmain
      include 'aba_param.inc'

      ! 読み込み用変数
      dimension array(513), jrray(nprecd,513),lrunit(2,1)
      equivalence (array(1),jrray(1,1))
      character fname*80

      ! ユーザー定義変数
      character outfile*80
      logical flg
      integer outkey,mode,outmode
      real value
      dimension value(6)

      read *, fname    ! 入力ファイル指定
      read *, outfile  ! 出力ファイル指定
      read *, outkey   ! キー指定
      read *, outmode   ! 番号指定

      ! 初期化
      nru=1
      lrunit(1,1)=8
      lrunit(2,1)=2
      loutf=0
      call initpf(fname,nru,lrunit,loutf)
      junit=8
      call dbrnu(junit)

      flg=.false.

      ! 出力ファイルオープン
      open(101, file = outfile, status = 'replace')

      do k1 = 1,2147483647

        ! レコードの読み込み
        call dbfile(0,array,jrcd)
        if(jrcd /= 0) exit
        key=jrray(1,2)

        ! モーダル
        if(key == 1980) then
          mode = jrray(1,3)
          if(mode == outmode) then
            flg=.true.
          else
            flg=.false.
          end if

        else if(key==1)then
          id=jrray(1,3)

        ! 指定キー出力
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

      ! 出力フォーマット定義
 1000 format(i8, e16.8e2, e16.8e2, e16.8e2, e16.8e2, e16.8e2, e16.8e2)

      end
