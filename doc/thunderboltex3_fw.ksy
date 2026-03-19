meta:
  id: thunderboltex3_fw
  endian: le
  title: ASUS ThunderboltEX 3 Firmware Image
  license: CC0-1.0
seq:
  - id: low_fw
    type: tps_header
    size: 4096
  - id: high_fw
    type: tps_header
    size: 4096
types:
  tps_header:
    doc-ref: "https://www.ti.com/lit/ug/slvuah7b/slvuah7b.pdf"
    instances:
      rptr:
        pos: 0
        type: u4
      aoff:
        pos: 0xffc
        type: u4
      intel_fw:
        pos: rptr
        type: intel_fw
        size: aoff
        if: (rptr > 0) and (aoff > 0) and (rptr < 0xffffffff) and (aoff < 0xffffffff)
        io: _root._io
      tps_fw:
        pos: rptr + aoff
        type: tps_fw
        if: (rptr > 0) and (aoff > 0) and (rptr < 0xffffffff) and (aoff < 0xffffffff)
        io: _root._io
  intel_fw:
    seq:
      - id: header
        size: 0x200
        type: intel_fw_header
      - id: sections
        type: section
        size: 0x200
    types:
      intel_fw_header:
        seq:
          - id: len
            type: u2
          - id: data
            size: len
            type: intel_fw_header_data
          - id: footer
            size: 8
        types:
          intel_fw_header_data:
            seq:
              - id: unk0
                type: u1
              - id: patches_offset
                type: u2
            instances:
              patches:
                pos: patches_offset
                type: patches
                io: _parent._parent._io
  tps_fw:
    seq:
      - id: header
        type: app_code_header
        size: 4096
      - id: app_code
        size: header.binary_size
    types:
      app_code_header:
        seq:
          - id: device_id
            type: u4
          - id: reserved0
            type: u4
          - id: boot_config_size
            type: u4
          - id: binary_size
            type: u4
          - id: binary_crc
            type: u4
          - id: reserved1
            type: u4
          - id: reserved2
            size: 40
          - id: device_config_pointer
            type: u4
  section:
    seq:
      - id: magic
        size: 8
        type: str
        encoding: ASCII
      - id: padding
        size: 8
      - id: data
        type:
          switch-on: magic
          cases:
            '"DROM    "': drom
            '"ARC PARM"': arc_parm
            '"EE_PCIE_"': ee_pcie_phi
            '"EE_DP   "': ee_dp
            '"ARC CACH"': arc_cache
            '"CSS     "': css
            '"RSA+EXP "': rsa_exp
            '"skip lis"': skip_list
            '"SEC DGST"': sec_dgst
            '"PATCHES "': patches
  drom:
    doc-ref: "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/thunderbolt/eeprom.c"
    seq:
      - id: header
        size: 22
        type: tb_drom_header
      - id: entries
        size: (header.data_len_and_unknown1 & 0x3ff) - 9
        type: entries
    types:
      tb_drom_header:
        seq:
          - id: uid_crc8
            type: u1
          - id: uid
            type: u8
          - id: data_crc32
            type: u4
          - id: device_rom_revision
            type: u1
          - id: data_len_and_unknown1
            type: u2
          - id: vendor_id
            type: u2
          - id: model_id
            type: u2
          - id: model_rev
            type: u1
          - id: eeprom_rev
            type: u1
      entries:
        seq:
          - id: entries
            type: entry
            repeat: eos
      entry:
        seq:
          - id: header
            type: tb_drom_entry_header
          - id: data
            if: '(header.len > 2 and header.type == tb_drom_entry_type::tb_drom_entry_generic) or (header.len >= 8 and header.type == tb_drom_entry_type::tb_drom_entry_port)'
            size: header.len - 2
            type:
              switch-on: header.type
              cases:
                tb_drom_entry_type::tb_drom_entry_generic: tb_drom_entry_generic
                tb_drom_entry_type::tb_drom_entry_port: tb_drom_entry_port
          - id: invalid_data
            size: header.len - 2
            if: 'not ((header.len > 2 and header.type == tb_drom_entry_type::tb_drom_entry_generic) or (header.len >= 8 and header.type == tb_drom_entry_type::tb_drom_entry_port))'
        types:
          tb_drom_entry_header:
            seq:
              - id: len
                type: u1
              - id: type
                type: b1
                enum: tb_drom_entry_type
              - id: port_disabled
                type: b1
              - id: index
                type: b6
          tb_drom_entry_generic:
            seq:
              - id: value
                type:
                  switch-on: _parent.header.index
                  cases:
                    1: vendor_name
                    2: device_name
            types:
              vendor_name:
                seq:
                  - id: vendor_name
                    size-eos: true
                    type: strz
                    encoding: ASCII
              device_name:
                seq:
                  - id: device_name
                    size-eos: true
                    type: strz
                    encoding: ASCII
          tb_drom_entry_port:
            seq:
              - id: has_dual_link_port
                type: b1
              - id: unknown1
                type: b2
              - id: link_nr
                type: b1
              - id: dual_link_port_rid
                type: b4
              - id: unknown2
                type: b2
              - id: dual_link_port_nr
                type: b6
              - id: micro1
                type: b4
              - id: micro2
                type: b4
              - id: micro3
                type: u1
              - id: has_peer_port
                type: b1
              - id: unknown3
                type: b3
              - id: peer_port_rid
                type: b4
              - id: unknown4
                type: b2
              - id: peer_port_nr
                type: b6
        enums:
          tb_drom_entry_type:
            0: tb_drom_entry_generic
            1: tb_drom_entry_port
  arc_parm:
    seq:
      - id: dwords
        type: u4
      - id: data
        size: dwords * 4
  ee_pcie_phi:
    seq:
      - id: data
        size: 0xd8
  ee_dp:
    seq:
      - id: dwords
        type: u1
      - id: unk
        size: 3
      - id: data
        size: dwords * 4
  arc_cache:
    seq:
      - id: dwords
        type: u4
      - id: data
        size: dwords * 4
  css:
    seq:
      - id: dwords
        type: u4
      - id: data
        size: dwords * 4
  rsa_exp:
    seq:
      - id: dwords
        type: u4
      - id: pub_n
        size: 256
      - id: pub_e
        type: u4
  skip_list:
    seq:
      - id: dwords
        type: u4
      - id: data
        size: dwords*4
  sec_dgst:
    seq:
      - id: dwords
        type: u4
      - id: sig
        size: 256
  patches:
    seq:
      - id: patch
        type: patch
        repeat: expr
        repeat-expr: 7
    types:
      patch:
        seq:
          - id: word_count
            type: u2
          - id: data
            size: word_count * 4
