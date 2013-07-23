
`define DECLARE_FMC(__nb) \
    logic       adc``__nb``_ext_trigger_p; \
    logic       adc``__nb``_ext_trigger_n; \
    logic       adc``__nb``_dco_p = 'b0; \
    logic       adc``__nb``_dco_n; \
    logic       adc``__nb``_fr_p; \
    logic       adc``__nb``_fr_n; \
    logic [3:0] adc``__nb``_outa_p; \
    logic [3:0] adc``__nb``_outa_n; \
    logic [3:0] adc``__nb``_outb_p; \
    logic [3:0] adc``__nb``_outb_n; \
    logic       adc``__nb``_spi_din; \
    logic       adc``__nb``_spi_dout; \
    logic       adc``__nb``_spi_sck; \
    logic       adc``__nb``_spi_cs_adc_n; \
    logic       adc``__nb``_spi_cs_dac1_n; \
    logic       adc``__nb``_spi_cs_dac2_n; \
    logic       adc``__nb``_spi_cs_dac3_n; \
    logic       adc``__nb``_spi_cs_dac4_n; \
    logic       adc``__nb``_gpio_dac_clr_n; \
    logic       adc``__nb``_gpio_led_acq; \
    logic       adc``__nb``_gpio_led_trig; \
    logic [6:0] adc``__nb``_gpio_ssr_ch1; \
    logic [6:0] adc``__nb``_gpio_ssr_ch2; \
    logic [6:0] adc``__nb``_gpio_ssr_ch3; \
    logic [6:0] adc``__nb``_gpio_ssr_ch4; \
    logic       adc``__nb``_gpio_si570_oe; \
    wire        adc``__nb``_si570_scl; \
    wire        adc``__nb``_si570_sda; \
    wire        adc``__nb``_one_wire; \
    logic       fmc``__nb``_prsnt_m2c_n; \
    wire        fmc``__nb``_scl; \
    wire        fmc``__nb``_sda;


`define WIRE_FMC(__nb) \
      .adc``__nb``_ext_trigger_p_i(adc``__nb``_ext_trigger_p), \
      .adc``__nb``_ext_trigger_n_i(adc``__nb``_ext_trigger_n), \
      .adc``__nb``_dco_p_i(adc``__nb``_dco_p), \
      .adc``__nb``_dco_n_i(adc``__nb``_dco_n), \
      .adc``__nb``_fr_p_i(adc``__nb``_fr_p), \
      .adc``__nb``_fr_n_i(adc``__nb``_fr_n), \
      .adc``__nb``_outa_p_i(adc``__nb``_outa_p), \
      .adc``__nb``_outa_n_i(adc``__nb``_outa_n), \
      .adc``__nb``_outb_p_i(adc``__nb``_outb_p), \
      .adc``__nb``_outb_n_i(adc``__nb``_outb_n), \
      .adc``__nb``_spi_din_i(adc``__nb``_spi_din), \
      .adc``__nb``_spi_dout_o(adc``__nb``_spi_dout), \
      .adc``__nb``_spi_sck_o(adc``__nb``_spi_sck), \
      .adc``__nb``_spi_cs_adc_n_o(adc``__nb``_spi_cs_adc_n), \
      .adc``__nb``_spi_cs_dac1_n_o(adc``__nb``_spi_cs_dac1_n), \
      .adc``__nb``_spi_cs_dac2_n_o(adc``__nb``_spi_cs_dac2_n), \
      .adc``__nb``_spi_cs_dac3_n_o(adc``__nb``_spi_cs_dac3_n), \
      .adc``__nb``_spi_cs_dac4_n_o(adc``__nb``_spi_cs_dac4_n), \
      .adc``__nb``_gpio_dac_clr_n_o(adc``__nb``_gpio_dac_clr_n), \
      .adc``__nb``_gpio_led_acq_o(adc``__nb``_gpio_led_acq), \
      .adc``__nb``_gpio_led_trig_o(adc``__nb``_gpio_led_trig), \
      .adc``__nb``_gpio_ssr_ch1_o(adc``__nb``_gpio_ssr_ch1), \
      .adc``__nb``_gpio_ssr_ch2_o(adc``__nb``_gpio_ssr_ch2), \
      .adc``__nb``_gpio_ssr_ch3_o(adc``__nb``_gpio_ssr_ch3), \
      .adc``__nb``_gpio_ssr_ch4_o(adc``__nb``_gpio_ssr_ch4), \
      .adc``__nb``_gpio_si570_oe_o(adc``__nb``_gpio_si570_oe), \
      .adc``__nb``_si570_scl_b(adc``__nb``_si570_scl), \
      .adc``__nb``_si570_sda_b(adc``__nb``_si570_sda), \
      .adc``__nb``_one_wire_b(adc``__nb``_one_wire), \
      .fmc``__nb``_prsnt_m2c_n_i(fmc``__nb``_prsnt_m2c_n), \
      .fmc``__nb``_scl_b(fmc``__nb``_scl), \
      .fmc``__nb``_sda_b(fmc``__nb``_sda),


