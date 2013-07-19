
`define DECLARE_DDR(__nb) \
    logic        ddr``__nb``_we_n; \
    wire  [1:0]  ddr``__nb``_dqs_p; \
    wire  [1:0]  ddr``__nb``_dqs_n; \
    wire  [1:0]  ddr``__nb``_dm; \
    logic        ddr``__nb``_reset_n; \
    logic        ddr``__nb``_ras_n; \
    logic        ddr``__nb``_odt; \
    logic        ddr``__nb``_cke; \
    logic        ddr``__nb``_ck_p; \
    logic        ddr``__nb``_ck_n; \
    logic        ddr``__nb``_cas_n; \
    wire  [15:0] ddr``__nb``_dq; \
    logic [2:0]  ddr``__nb``_ba; \
    logic [13:0] ddr``__nb``_a; \
    wire         ddr``__nb``_zio; \
    wire         ddr``__nb``_rzq; \
    ddr3 cmp_ddr``__nb`` ( \
        .rst_n(ddr``__nb``_reset_n), \
        .ck(ddr``__nb``_ck_p), \
        .ck_n(ddr``__nb``_ck_n), \
        .cke(ddr``__nb``_cke), \
        .cs_n(1'b0), \
        .ras_n(ddr``__nb``_ras_n), \
        .cas_n(ddr``__nb``_cas_n), \
        .we_n(ddr``__nb``_we_n), \
        .dm_tdqs(ddr``__nb``_dm), \
        .ba(ddr``__nb``_ba), \
        .addr(ddr``__nb``_a), \
        .dq(ddr``__nb``_dq), \
        .dqs(ddr``__nb``_dqs_p), \
        .dqs_n(ddr``__nb``_dqs_n), \
        .odt(ddr``__nb``_odt) \
        );


`define WIRE_DDR(__nb) \
    .ddr``__nb``_we_n_o(ddr``__nb``_we_n), \
    .ddr``__nb``_udqs_p_b(ddr``__nb``_dqs_p[1]), \
    .ddr``__nb``_udqs_n_b(ddr``__nb``_dqs_n[1]), \
    .ddr``__nb``_udm_o(ddr``__nb``_dm[1]), \
    .ddr``__nb``_reset_n_o(ddr``__nb``_reset_n), \
    .ddr``__nb``_ras_n_o(ddr``__nb``_ras_n), \
    .ddr``__nb``_odt_o(ddr``__nb``_odt), \
    .ddr``__nb``_ldqs_p_b(ddr``__nb``_dqs_p[0]), \
    .ddr``__nb``_ldqs_n_b(ddr``__nb``_dqs_n[0]), \
    .ddr``__nb``_ldm_o(ddr``__nb``_dm[0]), \
    .ddr``__nb``_cke_o(ddr``__nb``_cke), \
    .ddr``__nb``_ck_p_o(ddr``__nb``_ck_p), \
    .ddr``__nb``_ck_n_o(ddr``__nb``_ck_n), \
    .ddr``__nb``_cas_n_o(ddr``__nb``_cas_n), \
    .ddr``__nb``_dq_b(ddr``__nb``_dq), \
    .ddr``__nb``_ba_o(ddr``__nb``_ba), \
    .ddr``__nb``_a_o(ddr``__nb``_a), \
    .ddr``__nb``_zio_b(ddr``__nb``_zio), \
    .ddr``__nb``_rzq_b(ddr``__nb``_rzq),