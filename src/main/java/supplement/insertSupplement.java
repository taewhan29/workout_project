package supplement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import common.DBConnection;

public class insertSupplement {
    
    public List<SupplementDTO> getSupplementsByUserId(String userId) {
        List<SupplementDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM supplements WHERE user_id = ? ORDER BY supp_id DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                SupplementDTO dto = new SupplementDTO();
                dto.setSuppId(rs.getInt("supp_id"));
                dto.setUserId(rs.getString("user_id"));
                dto.setSuppName(rs.getString("supp_name"));
                dto.setBrand(rs.getString("brand"));
                dto.setCurrentServings(rs.getInt("current_servings"));
                dto.setDosage(rs.getInt("dosage"));
                dto.setMinThreshold(rs.getInt("min_threshold"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return list;
    }
    
    public boolean takeSupplement(int suppId, int dosage) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE supplements SET current_servings = GREATEST(0, current_servings - ?) WHERE supp_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dosage);
            pstmt.setInt(2, suppId);
            
            int count = pstmt.executeUpdate();
            if(count > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return result;
    }

    public boolean insertSupplement(SupplementDTO dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO supplements (user_id, supp_name, brand, current_servings, dosage, min_threshold) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUserId());
            pstmt.setString(2, dto.getSuppName());
            pstmt.setString(3, dto.getBrand());
            pstmt.setDouble(4, dto.getCurrentServings());
            pstmt.setInt(5, dto.getDosage());
            pstmt.setDouble(6, dto.getMinThreshold());
            
            int count = pstmt.executeUpdate();
            if(count > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return result;
    }
}