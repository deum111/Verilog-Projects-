`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2019 06:13:29 PM
// Design Name: 
// Module Name: mult64x64
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mult64x64
    ( a,
      b,
      sum
    );
    
    input  [63:0] a;
    input  [63:0] b;
    output [127:0] sum;
	
	reg [63:0] m1;
	reg [64:0] m2;
	reg [65:0] m3;
	reg [66:0] m4;
	reg [67:0] m5;
	reg [68:0] m6;
	reg [69:0] m7;
	reg [70:0] m8;
	reg [71:0] m9;
	reg [72:0] m10;
	reg [73:0] m11;
	reg [74:0] m12;
	reg [75:0] m13;
	reg [76:0] m14;
	reg [77:0] m15;
	reg [78:0] m16;
	reg [79:0] m17;
	reg [80:0] m18;
	reg [81:0] m19;
	reg [82:0] m20;
	reg [83:0] m21;
	reg [84:0] m22;
	reg [85:0] m23;
	reg [86:0] m24;
	reg [87:0] m25;
	reg [88:0] m26;
	reg [89:0] m27;
	reg [90:0] m28;
	reg [91:0] m29;
	reg [92:0] m30;
	reg [93:0] m31;
	reg [94:0] m32;
	reg [95:0] m33;
	reg [96:0] m34;
	reg [97:0] m35;
	reg [98:0] m36;
	reg [99:0] m37;
	reg [100:0] m38;
	reg [101:0] m39;
	reg [102:0] m40;
	reg [103:0] m41;
	reg [104:0] m42;
	reg [105:0] m43;
	reg [106:0] m44;
	reg [107:0] m45;
	reg [108:0] m46;
	reg [109:0] m47;
	reg [110:0] m48;
	reg [111:0] m49;
	reg [112:0] m50;
	reg [113:0] m51;
	reg [114:0] m52;
	reg [115:0] m53;
	reg [116:0] m54;
	reg [117:0] m55;
	reg [118:0] m56;
	reg [119:0] m57;
	reg [120:0] m58;
	reg [121:0] m59;
	reg [122:0] m60;
	reg [123:0] m61;
	reg [124:0] m62;
	reg [125:0] m63;
	reg [126:0] m64;
	
	always @(a or b) begin
	if(b[0]==1'b0)
		m1[63:0] <= 0;
	else 
		m1[63:0] <= a;
		
	if(b[1]==1'b0)
		m2[64:0] <= 0;
	else begin
		m2[0] <= 0;
		m2[64:1] <= a;
	end
	
	if(b[2]==1'b0)
		m3[65:0] <= 0;
	else begin
		m3[1:0] <= 0;
		m3[65:2] <= a;
	end	
	
	if(b[3]==1'b0)
		m4[66:0] <= 0;
	else begin
		m4[2:0] <= 0;
		m4[66:3] <= a;
	end	
	
	if(b[4]==1'b0)
		m5[67:0] <= 0;
	else begin
		m5[3:0] <= 0;
		m5[67:4] <= a;
	end

	if(b[5]==1'b0)
		m6[68:0] <= 0;
	else begin
		m6[4:0] <= 0;
		m6[68:5] <= a;
	end

	if(b[6]==1'b0)
		m7[69:0] <= 0;
	else begin
		m7[5:0] <= 0;
		m7[69:6] <= a;
	end

	if(b[7]==1'b0)
		m8[70:0] <= 0;
	else begin
		m8[6:0] <= 0;
		m8[70:7] <= a;
	end

	if(b[8]==1'b0)
		m9[71:0] <= 0;
	else begin
		m9[7:0] <= 0;
		m9[71:8] <= a;
	end

	if(b[9]==1'b0)
		m10[72:0] <= 0;
	else begin
		m10[8:0] <= 0;
		m10[72:9] <= a;
	end

	if(b[10]==1'b0)
		m11[73:0] <= 0;
	else begin
		m11[9:0] <= 0;
		m11[73:10] <= a;
	end

	if(b[11]==1'b0)
		m12[74:0] <= 0;
	else begin
		m12[10:0] <= 0;
		m12[74:11] <= a;
	end

	if(b[12]==1'b0)
		m13[75:0] <= 0;
	else begin
		m13[11:0] <= 0;
		m13[75:12] <= a;
	end

	if(b[13]==1'b0)
		m14[76:0] <= 0;
	else begin
		m14[12:0] <= 0;
		m14[76:13] <= a;
	end

	if(b[14]==1'b0)
		m15[77:0] <= 0;
	else begin
		m15[13:0] <= 0;
		m15[77:14] <= a;
	end

	if(b[15]==1'b0)
		m16[78:0] <= 0;
	else begin
		m16[14:0] <= 0;
		m16[78:15] <= a;
	end

	if(b[16]==1'b0)
		m17[79:0] <= 0;
	else begin
		m17[15:0] <= 0;
		m17[79:16] <= a;
	end

	if(b[17]==1'b0)
		m18[80:0] <= 0;
	else begin
		m18[16:0] <= 0;
		m18[80:17] <= a;
	end

	if(b[18]==1'b0)
		m19[81:0] <= 0;
	else begin
		m19[17:0] <= 0;
		m19[81:18] <= a;
	end
	
	if(b[19]==1'b0)
		m20[82:0] <= 0;
	else begin
		m20[18:0] <= 0;
		m20[82:19] <= a;
	end	
	
	if(b[20]==1'b0)
		m21[83:0] <= 0;
	else begin
		m21[19:0] <= 0;
		m21[83:20] <= a;
	end	
	
	if(b[21]==1'b0)
		m22[84:0] <= 0;
	else begin
		m22[20:0] <= 0;
		m22[84:21] <= a;
	end	
	
	if(b[22]==1'b0)
		m23[85:0] <= 0;
	else begin
		m23[21:0] <= 0;
		m23[85:22] <= a;
	end

	if(b[23]==1'b0)
		m24[86:0] <= 0;
	else begin
		m24[22:0] <= 0;
		m24[86:23] <= a;
	end	

	if(b[24]==1'b0)
		m25[87:0] <= 0;
	else begin
		m25[23:0] <= 0;
		m25[87:24] <= a;
	end	

	if(b[25]==1'b0)
		m26[88:0] <= 0;
	else begin
		m26[24:0] <= 0;
		m26[88:25] <= a;
	end

	if(b[26]==1'b0)
		m27[89:0] <= 0;
	else begin
		m27[25:0] <= 0;
		m27[89:26] <= a;
	end
	
	if(b[27]==1'b0)
		m28[90:0] <= 0;
	else begin
		m28[26:0] <= 0;
		m28[90:27] <= a;
	end	
	
	if(b[28]==1'b0)
		m29[91:0] <= 0;
	else begin
		m29[27:0] <= 0;
		m29[91:28] <= a;
	end	
	
	if(b[29]==1'b0)
		m30[92:0] <= 0;
	else begin
		m30[28:0] <= 0;
		m30[92:29] <= a;
	end	
	
	if(b[30]==1'b0)
		m31[93:0] <= 0;
	else begin
		m31[29:0] <= 0;
		m31[93:30] <= a;
	end		
	
	if(b[31]==1'b0)
		m32[94:0] <= 0;
	else begin
		m32[30:0] <= 0;
		m32[94:31] <= a;
	end		
	
	if(b[32]==1'b0)
		m33[95:0] <= 0;
	else begin
		m33[31:0] <= 0;
		m33[95:32] <= a;
	end		
	
	if(b[33]==1'b0)
		m34[96:0] <= 0;
	else begin
		m34[32:0] <= 0;
		m34[96:33] <= a;
	end		
	
	if(b[34]==1'b0)
		m35[97:0] <= 0;
	else begin
		m35[33:0] <= 0;
		m35[97:34] <= a;
	end		
	
	if(b[35]==1'b0)
		m36[98:0] <= 0;
	else begin
		m36[34:0] <= 0;
		m36[98:35] <= a;
	end		
	
	if(b[36]==1'b0)
		m37[99:0] <= 0;
	else begin
		m37[35:0] <= 0;
		m37[99:36] <= a;
	end		
	
	if(b[37]==1'b0)
		m38[100:0] <= 0;
	else begin
		m38[36:0] <= 0;
		m38[100:37] <= a;
	end		
	
	if(b[38]==1'b0)
		m39[101:0] <= 0;
	else begin
		m39[37:0] <= 0;
		m39[101:38] <= a;
	end		
	
	if(b[39]==1'b0)
		m40[102:0] <= 0;
	else begin
		m40[38:0] <= 0;
		m40[102:39] <= a;
	end		
	
	if(b[40]==1'b0)
		m41[103:0] <= 0;
	else begin
		m41[39:0] <= 0;
		m41[103:40] <= a;
	end		
	
	if(b[41]==1'b0)
		m42[104:0] <= 0;
	else begin
		m42[40:0] <= 0;
		m42[104:41] <= a;
	end		
	
	if(b[42]==1'b0)
		m43[105:0] <= 0;
	else begin
		m43[41:0] <= 0;
		m43[105:42] <= a;
	end		
	
	if(b[43]==1'b0)
		m44[106:0] <= 0;
	else begin
		m44[42:0] <= 0;
		m44[106:43] <= a;
	end		
	
	if(b[44]==1'b0)
		m45[107:0] <= 0;
	else begin
		m45[43:0] <= 0;
		m45[107:44] <= a;
	end		
	
	if(b[45]==1'b0)
		m46[108:0] <= 0;
	else begin
		m46[44:0] <= 0;
		m46[108:45] <= a;
	end		
	
	if(b[46]==1'b0)
		m47[109:0] <= 0;
	else begin
		m47[45:0] <= 0;
		m47[109:46] <= a;
	end		
	
	if(b[47]==1'b0)
		m48[110:0] <= 0;
	else begin
		m48[46:0] <= 0;
		m48[110:47] <= a;
	end		
	
	if(b[48]==1'b0)
		m49[111:0] <= 0;
	else begin
		m49[47:0] <= 0;
		m49[111:48] <= a;
	end		
	
	if(b[49]==1'b0)
		m50[112:0] <= 0;
	else begin
		m50[48:0] <= 0;
		m50[112:49] <= a;
	end		
	
	if(b[50]==1'b0)
		m51[113:0] <= 0;
	else begin
		m51[49:0] <= 0;
		m51[113:50] <= a;
	end		
	
	if(b[51]==1'b0)
		m52[114:0] <= 0;
	else begin
		m52[50:0] <= 0;
		m52[114:51] <= a;
	end		
	
	if(b[52]==1'b0)
		m53[115:0] <= 0;
	else begin
		m53[51:0] <= 0;
		m53[115:52] <= a;
	end			
	
	if(b[53]==1'b0)
		m54[116:0] <= 0;
	else begin
		m54[52:0] <= 0;
		m54[116:53] <= a;
	end			
	
	if(b[54]==1'b0)
		m55[117:0] <= 0;
	else begin
		m55[53:0] <= 0;
		m55[117:54] <= a;
	end			
	
	if(b[55]==1'b0)
		m56[118:0] <= 0;
	else begin
		m56[54:0] <= 0;
		m56[118:55] <= a;
	end			
	
	if(b[56]==1'b0)
		m57[119:0] <= 0;
	else begin
		m57[55:0] <= 0;
		m57[119:56] <= a;
	end			
	
	if(b[57]==1'b0)
		m58[120:0] <= 0;
	else begin
		m58[56:0] <= 0;
		m58[120:57] <= a;
	end			
	
	if(b[58]==1'b0)
		m59[121:0] <= 0;
	else begin
		m59[57:0] <= 0;
		m59[121:58] <= a;
	end			
	
	if(b[59]==1'b0)
		m60[122:0] <= 0;
	else begin
		m60[58:0] <= 0;
		m60[122:59] <= a;
	end			
	
	if(b[60]==1'b0)
		m61[123:0] <= 0;
	else begin
		m61[59:0] <= 0;
		m61[123:60] <= a;
	end			
	
	if(b[61]==1'b0)
		m62[124:0] <= 0;
	else begin
		m62[60:0] <= 0;
		m62[124:61] <= a;
	end		

	if(b[62]==1'b0)
		m63[125:0] <= 0;
	else begin
		m63[61:0] <= 0;
		m63[125:62] <= a;
	end

	if(b[63]==1'b0)
		m64[126:0] <= 0;
	else begin
		m64[62:0] <= 0;
		m64[126:63] <= a;
	end
	
end

	assign sum = m1+m2+m3+m4+m5+m6+m7+m8+m9+m10+m11+m12+m13+m14+m15+m16+m17+m18+m19+m20+m21+m22+m23+m24+m25+m26+m27+m28+m29+m30+m31+m32+m33+m34+m35+m36+m37+m38+m39+m40+m41+m42+m43+m44+m45+m46+m47+m48+m49+m50+m51+m52+m53+m54+m55+m56+m57+m58+m59+m60+m61+m62+m63+m64;

endmodule
