from archive.models import ArchiveDao


class ArchiveManager():

    def __init__(self):
        self.dao = ArchiveDao()

    def clear(self):
        all_archive = self.dao.get_all_archive()
        for archive in all_archive:
            self.dao.delete_archive(archive)

    def add_archive(self, uid, sid, src, result):
        if self.dao.user_and_stage_is_valid(uid, sid):
            all_archive = self.dao.get_all_archive()
            if len(all_archive) > 0:
                arid = all_archive[-1].arid + 1
            else:
                arid = 1

            self.dao.create_archive(arid, uid, sid, src, result)
            return 'Succeeded. New archive #' + str(arid)
        else:
            return 'Uid or sid is invalid.'

    def update_archive(self, arid, new_uid, new_sid, new_src, new_result):
        cur_archive = self.dao.get_archive_by_arid(arid)
        if cur_archive:
            if new_uid > 0:
                self.dao.update_archive_uid(cur_archive, new_uid)
            if new_sid > 0:
                self.dao.update_archive_sid(cur_archive, new_sid)
            if len(new_src) > 0:
                self.dao.update_archive_src(cur_archive, new_src)
            if len(new_result) > 0:
                self.dao.update_archive_result(cur_archive, new_result)
            return 'Succeeded.'
        else:
            return 'Archive #%s does not exist' % (str(arid))

    def delete_archive(self, arid):
        cur_archive = self.dao.get_archive_by_arid(arid)
        if cur_archive:
            self.dao.delete_archive(cur_archive)
            return 'Succeeded.'
        else:
            return 'Succeeded, nothing is done.'

    def search_archive(self, uid, sid, arid=0):
        if arid > 0:
            cur_archive = self.dao.get_archive_by_arid(arid)
            if cur_archive and cur_archive.uid == uid and cur_archive.sid == sid:
                return [cur_archive]
            else:
                return []

        else:
            targets = self.dao.get_all_archive_by_uid_and_sid(uid, sid)
            return targets

    def load_code(self, uid, sid):
        if self.dao.user_and_stage_is_valid(uid, sid):
            targets = self.dao.get_all_archive_by_uid_and_sid(uid, sid)
            if len(targets) > 0:
                return targets[-1].src
            else:
                return ''
        else:
            return None

    def get_result(self, uid, sid):
        if self.dao.user_and_stage_is_valid(uid, sid):
            targets = self.dao.get_all_archive_by_uid_and_sid(uid, sid)
            if len(targets) > 0:
                return targets[-1].result
            else:
                return ''
        else:
            return None

    def get_stage_record_count(self, sid):
        if self.dao.user_and_stage_is_valid(1, sid):
            targets = self.dao.get_all_archive_by_uid_and_sid(0, sid)
            return len(targets)
        else:
            return 0
