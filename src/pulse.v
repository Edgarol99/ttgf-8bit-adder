module detector_boton (
    input wire clk,
    input wire rst,
    input wire boton,   
    output reg pulso_press 
);

    reg boton_anterior;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            boton_anterior <= 1'b0;
            pulso_press    <= 1'b0;
        end else begin
            // Es '1' SOLO en el ciclo donde boton es 1 Y antes era 0
            pulso_press    <= (boton == 1'b1) && (boton_anterior == 1'b0);
            
            // Guardamos el estado actual para compararlo en el siguiente ciclo
            boton_anterior <= boton;
        end
    end

endmodule
